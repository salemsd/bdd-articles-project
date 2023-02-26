from flask import Flask, render_template, request, redirect, url_for, session
from passlib.context import CryptContext
import db

app = Flask(__name__)

app.secret_key = b'31dq01c987b6f7f0d5896be06c4f418b9be320d62341abff24aec19297cd80a'

password_ctx=CryptContext(schemes=['bcrypt'])

def admin_check():
    return "nom_admin" in session

@app.route("/accueil")
def acc():
    admin = admin_check()
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("select count(id_art) as nb_art from article;")
            nb_art = cur.fetchone().nb_art
            cur.execute("Select id_art_cite, titre, count(cite.id_art) as nb_cite from cite,article where cite.id_art_cite = article.id_art group by id_art_cite, titre order by nb_cite desc limit 5;")
            lst_cite = cur.fetchall()
    
    return render_template("accueil.html", nb_art = nb_art, lst_cite = lst_cite, admin = admin)

@app.route("/recherche")
def page_rech():
    admin = admin_check()
    mode = request.args.get("mode", None)
    if mode == None:
        mode = "titre" # Valeur par défaut: recherche par titre (quand on recherche depuis l'accueil)
    elif mode == "auteur":
        mode = "concat(prenom, ' ', nom)"

    rech = request.args.get("rech", None)
    lst_resultat = None

    with db.connect() as conn:
        with conn.cursor() as cur:
            if mode != "annee":
                rech_pattern = '%{}%'.format(rech)
                cur.execute(f"""select id_auteur, id_art, titre, nom, prenom, nom_domaine, langue, annee, volume 
                                from article natural join auteur natural join affilie natural join appartient 
                                where {mode} ilike %s""", (rech_pattern,))
                lst_resultat = cur.fetchall()

            else:
                if rech != '':
                    cur.execute("""select id_auteur, id_art, titre, nom, prenom, nom_domaine, langue, annee, volume 
                                    from article natural join auteur natural join affilie natural join appartient 
                                    where annee = %s""", (rech,))
                    lst_resultat = cur.fetchall()

    return render_template("recherche.html", mode = mode, rech = rech, lst_resultat = lst_resultat, admin = admin)

@app.route("/comites")
def com():
    admin = admin_check()

    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("select id_comite, nom, prenom from auteur order by id_comite")
            lst = cur.fetchall()
    return render_template("comites.html",lst = lst, admin = admin)

@app.route("/articles")
def art():
    admin = admin_check()

    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("""select id_auteur, id_art, titre, nom, prenom, nom_domaine, langue, annee, volume 
                            from article natural join auteur natural join affilie natural join appartient order by(titre)""")
            lst = cur.fetchall()
    return render_template("articles.html", lst_art = lst, admin = admin)

@app.route("/auteurs")
def aut():
    admin = admin_check()

    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("""Select id_auteur, nom, prenom, count(id_art) as nb_art 
                            from affilie natural join auteur natural join labo
                            group by id_auteur, nom, prenom order by nom""")
            lst = cur.fetchall()
    return render_template("auteur.html",lst_aut = lst, admin = admin)

@app.route("/articles/<ida>")
def infart(ida):
    admin = admin_check()

    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute(f"select * from article where id_art = %s", (ida,))
            lst = cur.fetchone()
            cur.execute(f"Select id_auteur,nom,prenom from auteur natural join affilie where id_art = %s", (ida,)) 
            lst2 = cur.fetchall()
            cur.execute(f"select nom_revue, numero_revue from article natural join revue where id_art = %s", (ida,))
            lst_rev = cur.fetchone()
    if lst is None :
        return render_template("Erreur.html")
    return render_template("artinfo.html",lst = lst,lst2 = lst2, lst_rev = lst_rev, admin = admin)

@app.route("/auteurs/<infa>")
def c_auteur(infa):
    admin = admin_check()

    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("select * from auteur where id_auteur = (%s)", (infa,))
            lst = cur.fetchone()
            cur.execute("Select id_art,titre from article natural join affilie where id_auteur = (%s)", (infa,))
            lst2 = cur.fetchall()
            cur.execute("select distinct nom_labo, adresse, pays from auteur natural join labo natural join affilie where id_auteur = %s", (infa,))
            lst_lab = cur.fetchall()
    if lst is None :
        return render_template("Erreur.html")
    return render_template("autinfo.html",lst = lst,lst2 = lst2, lst_lab = lst_lab, admin = admin)

#Ajoute article
@app.route("/formart")
def formart():
    if "nom_admin" in session:
        return render_template("formart.html")
    return redirect(url_for("login"))

#Reçu de l'ajout d'article
@app.route("/regart", methods = ["post"])
def regart():
    admin = admin_check()

    form_titre = request.form.get("titre")
    form_lang = request.form.get("langue")
    form_nbr = request.form.get("nbr_page")
    form_annee = request.form.get("annee")
    form_volume = request.form.get("volume")
    if not form_titre or not form_lang or not form_nbr or not form_annee or not form_volume:
        return redirect(url_for("formart"))
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("Select max(id_art) from article")
            id = cur.fetchone()
            id = id[0] + 1
        with conn.cursor() as cur:
            cur.execute("insert into article(id_art,titre,langue,nbr_page,annee,volume) values(%s,%s,%s,%s,%s,%s)",(id,form_titre,form_lang,form_nbr,form_annee,form_volume))
        with conn.cursor() as cur:
            cur.execute("""select id_auteur, id_art, titre, nom, prenom, nom_domaine, langue, annee, volume 
                            from article natural join auteur natural join affilie natural join appartient order by(titre)""")
            lst = cur.fetchall()
    return render_template("articles.html", lst_art = lst,mot = "L'article a bien été ajouté", admin = admin)      

#Supprime un article
@app.route("/suppart/<idsupp>")
def supp(idsupp):
    admin = admin_check()
    if not admin:
        return redirect(url_for("login"))

    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("DELETE FROM article where id_art = (%s)",(idsupp,))
        with conn.cursor() as cur:
            cur.execute("""select id_auteur, id_art, titre, nom, prenom, nom_domaine, langue, annee, volume 
                            from article natural join auteur natural join affilie natural join appartient order by(titre)""")
            lst = cur.fetchall()
    return render_template("articles.html",lst_art = lst, mot = "L'article a bien été supprimé", admin = admin)

@app.route("/modart/<ida>")
#modifie article
def modif(ida):
    if "nom_admin" not in session:
        return redirect(url_for("login"))
    
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("Select * from article where id_art = (%s)",(ida,))
            lst = cur.fetchone()
    return render_template("modif.html",lst = lst)

@app.route("/savmodart/<ida>",methods = ["post"])
#enregistre la modification
def savemod(ida):
    admin = admin_check()

    form_titre = request.form.get("titre")
    form_lang = request.form.get("langue")
    form_nbr = request.form.get("nbr_page")
    form_annee = request.form.get("annee")
    form_volume = request.form.get("volume")
    with db.connect() as conn:
        if not form_titre :
            with conn.cursor() as cur:
                cur.execute("Select titre from article where id_art = (%s)",(ida,))
                form_titre = cur.fetchone()
        if not form_lang :
            with conn.cursor() as cur:
                cur.execute("Select langue from article where id_art = (%s)",(ida,))
                form_lang = cur.fetchone()
        if not form_nbr:
            with conn.cursor() as cur:
                cur.execute("Select nbr_page from article where id_art = (%s)",(ida,))
                form_nbr = cur.fetchone() 
        if not form_annee :
            with conn.cursor() as cur:
                cur.execute("Select annee from article where id_art = (%s)",(ida,))
                form_annee = cur.fetchone()
        if not form_volume:
            with conn.cursor() as cur:
                cur.execute("Select volume from article where id_art = (%s)",(ida,))
                form_volume = cur.fetchone()
        with conn.cursor() as cur:
            cur.execute("UPDATE article SET titre = (%s), langue = (%s), nbr_page = (%s), annee = (%s), volume = (%s) where id_art = (%s)",(form_titre,form_lang,form_nbr,form_annee,form_volume,ida))
        with conn.cursor() as cur:
            cur.execute("""select id_auteur, id_art, titre, nom, prenom, nom_domaine, langue, annee, volume 
                            from article natural join auteur natural join affilie natural join appartient order by(titre)""")
            lst = cur.fetchall()
    return render_template("articles.html", lst_art = lst, mot = "Cet article a bien été modifié", admin = admin) 

#Ajoute Auteur
@app.route("/formaut")
def formaut():
    if "nom_admin" not in session:
        return redirect(url_for("login"))
    return render_template("formaut.html")

#Reçu de l'ajout d'auteur
@app.route("/regaut", methods = ["post"])
def regaut():
    admin = admin_check()

    form_nom = request.form.get("nom")
    form_prenom = request.form.get("prenom")
    form_coord = request.form.get("coord")
    form_comite = request.form.get("comite")
    if not form_nom or not form_prenom :
        return redirect(url_for("formart"))
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("Select max(id_auteur) from auteur")
            id = cur.fetchone()
            id = id[0] + 1
        with conn.cursor() as cur:
            cur.execute("insert into auteur(id_auteur,nom,prenom,num_auteur,id_comite) values(%s,%s,%s,%s,%s)",(id,form_nom,form_prenom,form_coord,form_comite))
        with conn.cursor() as cur:
            cur.execute("""Select id_auteur, nom, prenom, count(id_art) as nb_art 
                            from affilie natural join auteur natural join labo
                            group by id_auteur, nom, prenom order by nom""")
            lst = cur.fetchall()
    return render_template("auteur.html",lst_aut = lst, mot ="L'auteur a bien été ajouté", admin = admin)

#Supprime un auteur
@app.route("/suppaut/<idsupp>")
def suppaut(idsupp):
    admin = admin_check()

    if not admin:
        return redirect(url_for("login"))

    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("DELETE FROM auteur where id_auteur = (%s)",(idsupp,))
        with conn.cursor() as cur:
            cur.execute("""Select id_auteur, nom, prenom, count(id_art) as nb_art 
                            from affilie natural join auteur natural join labo
                            group by id_auteur, nom, prenom order by nom""")
            lst = cur.fetchall()
    return render_template("auteur.html",lst_aut = lst, mot = "L'auteur a bien été supprimé", admin = admin)

@app.route("/modaut/<ida>")
#modifie auteur
def modaut(ida):
    if "nom_admin" not in session:
        return redirect(url_for("login"))

    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("Select * from auteur where id_auteur = (%s)",(ida,))
            lst = cur.fetchone()
    return render_template("modifaut.html",lst = lst)

@app.route("/savmodaut/<ida>",methods = ["post"])
#enregistre la modification
def savemodaut(ida):
    admin = admin_check()
    
    form_nom = request.form.get("nom")
    form_prenom = request.form.get("prenom")
    form_coord = request.form.get("coord")
    form_comite = request.form.get("comite")
    with db.connect() as conn:
        if not form_nom :
            with conn.cursor() as cur:
                cur.execute("Select nom from auteur where id_auteur = (%s)",(ida,))
                form_nom = cur.fetchone()
        if not form_prenom :
            with conn.cursor() as cur:
                cur.execute("Select prenom from auteur where id_auteur = (%s)",(ida,))
                form_prenom = cur.fetchone()
        if not form_coord:
            with conn.cursor() as cur:
                cur.execute("Select num_auteur from auteur where id_auteur = (%s)",(ida,))
                form_nbr = cur.fetchone() 
        if not form_comite :
            with conn.cursor() as cur:
                cur.execute("Select id_comite from auteur where id_auteur = (%s)",(ida,))
                form_comite = cur.fetchone()
        with conn.cursor() as cur:
            cur.execute("UPDATE auteur SET nom = (%s), prenom = (%s), num_auteur = (%s),  id_comite = (%s) where id_auteur = (%s)",(form_nom,form_prenom,form_coord,form_comite,ida))
        with conn.cursor() as cur:
            cur.execute("""Select id_auteur, nom, prenom, count(id_art) as nb_art 
                            from affilie natural join auteur natural join labo
                            group by id_auteur, nom, prenom order by nom""")
            lst = cur.fetchall()
    return render_template("auteur.html", lst_aut = lst, mot = "Cet auteur a bien été modifié", admin = admin) 

@app.route("/angele")
def angele():
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("Select * from auteur where id_auteur = 7")
            lst = cur.fetchone()
    return render_template("angele.html",lst = lst)

### Connexion admin

# Page de connexion
@app.route("/connexion")
def login():
    if "nom_admin" in session:
        return redirect(url_for("acc"))
    return render_template("connexion.html")

# Cérification de la connexion
@app.route("/verification", methods = ['POST'])
def connect():
    nom_admin = request.form.get("nom-admin",None)
    password = request.form.get("mdp", None)

    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("select * from admins where nom_utilisateur = %s", (nom_admin,))
            res = cur.fetchone()
    
    if res.nom_utilisateur == nom_admin and password_ctx.verify(password, res.mdp):
        session["nom_admin"] = nom_admin
        return redirect(url_for("acc"))

    return redirect(url_for("login"))

# Page d'ajout admin
@app.route("/ajout_adm")
def register():
    if "nom_admin" not in session:
        return(redirect(url_for("login")))
        
    nom_admin = request.args.get("nom-admin", None)
    password = request.args.get("mdp", None)
    
    if nom_admin and password:
        hash_pw = password_ctx.hash(password)

        with db.connect() as conn:
            with conn.cursor() as cur:
                cur.execute("insert into admins(nom_utilisateur, mdp) values(%s,%s)", (nom_admin, hash_pw))

    return render_template("ajout_admin.html")

# Deconnexion
@app.route("/deconnexion")
def logout():
    if "nom_admin" in session:
        session.pop("nom_admin")
    return redirect(url_for("login"))

@app.route("/info")
def info():
    admin = admin_check()
    return render_template("info.html", admin = admin)

if __name__ == '__main__':
    app.run(debug=True)