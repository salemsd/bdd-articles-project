-- Schéma relationnel:
    -- revue(**id_revue**, numero_revue, id_comite)
    -- article(**id_art**, titre, langue, nbr_page, annee, id_revue, volume)
    -- domaine(**nom_domaine**)
    -- comite(**id_comite**)
    -- auteur(**id_auteur**, nom, prenom, num_auteur, id_comite)
    -- labo(**id_labo**, adresse, pays)
    -- affilie(**id_art, id_auteur, id_labo**)
    -- appartient(**id_art, nom_domaine**)
    -- cite(**id_art id_art_cite**)
    -- FK:
        -- id_comite dans revue réf comite(id_comite)
        -- id_revue dans article réf revue(id_revue)
        -- id_comite dans autueur réf comite(id_comite)
        -- id_art dans affilie réf article(id_art)
        -- id_auteur dans affilie réf auteur(id_auteur)
        -- id_labo dans affilie réf labo(id_labo)
        -- id_art dans appartient réf article(id_art)
        -- nom_domaine dans appartient réf domaine(nom_domaine)
        -- id_art dans cite réf article(id_art)
        -- id_art_cite dans cite réf article(id_art)

-- Drop les tables

DROP TABLE IF EXISTS revue CASCADE;
DROP TABLE IF EXISTS article CASCADE;
DROP TABLE IF EXISTS domaine CASCADE;
DROP TABLE IF EXISTS comite CASCADE;
DROP TABLE IF EXISTS auteur CASCADE;
DROP TABLE IF EXISTS labo CASCADE;
DROP TABLE IF EXISTS affilie CASCADE;
DROP TABLE IF EXISTS appartient CASCADE;
DROP TABLE IF EXISTS cite CASCADE;
DROP TABLE IF EXISTS admins CASCADE;

-- Créer les tables

CREATE TABLE comite (
	id_comite int primary key
);

CREATE TABLE labo (
	id_labo int primary key,
    nom_labo varchar(100),
	adresse text not null,
    pays varchar(25) not null
);

CREATE TABLE revue (
	id_revue int primary key,
    nom_revue varchar(50),
	numero_revue int not null,
    id_comite int,
    constraint revue_id_comite_fkey foreign key (id_comite) references comite(id_comite) on update cascade
);

CREATE TABLE article (
	id_art int primary key,
	titre text not null,
    langue varchar(15) not null,
    nbr_page int not null,
    annee int not null,
    volume varchar(4) not null,
    id_revue int,
    constraint chk_nbr_page check (nbr_page > 0),
    constraint article_id_revue_fkey foreign key (id_revue) references revue(id_revue) on update cascade
);

CREATE TABLE domaine (
	nom_domaine varchar(50) primary key
);

CREATE TABLE auteur (
	id_auteur int primary key,
	nom varchar(25) not null,
    prenom varchar(25) not null,
    num_auteur char(10),
    id_comite int,
    constraint auteur_id_comite_fkey foreign key(id_comite) references comite(id_comite) on update cascade
);


CREATE TABLE affilie (
	id_art int,
	id_auteur int,
    id_labo int,
	constraint cle_prim_affilie primary key(id_art, id_auteur, id_labo),
    constraint affilie_id_art_fkey foreign key(id_art) references article(id_art) on update cascade on delete cascade,
    constraint affilie_id_auteur_fkey foreign key(id_auteur) references auteur(id_auteur) on update cascade on delete cascade,
    constraint affilie_id_labo_fkey foreign key(id_labo) references labo(id_labo) on update cascade on delete cascade
);

CREATE TABLE appartient (
	id_art int,
	nom_domaine varchar(50),
	constraint cle_prim_appartient primary key(id_art, nom_domaine),
    constraint appartient_id_art_fkey foreign key(id_art) references article(id_art) on update cascade on delete cascade,
    constraint appartient_nom_domaine_fkey foreign key(nom_domaine) references domaine(nom_domaine) on update cascade on delete cascade
);

CREATE TABLE cite (
	id_art int,
    id_art_cite int,
	constraint cle_prim_cite primary key(id_art, id_art_cite),
    constraint cite_id_art_fkey foreign key(id_art) references article(id_art) on update cascade on delete cascade,
    constraint cite_id_art_cite_fkey foreign key(id_art_cite) references article(id_art) on update cascade on delete cascade
);

CREATE TABLE admins (
	nom_utilisateur varchar(25) primary key,
    mdp text not null
);

-- Insertions

--
-- Data for Name: Comité
--

COPY comite FROM STDIN csv;
0
1
2
3
4
5
6
7
8
9
10
11
12
13
\.

--
-- Data for Name: Labo
--

COPY labo FROM STDIN csv;
0,Iceland Genomics Corporation,"7163 Roskothweg, 39943, Almería",Islande
1,Abbott France,"50 chemin de Meunier, 18700, Ledoux",France
2,Bleu-Labo,"43 Via Casarin, 35900, Monschau",Suisse
3,Toronto National Lab,"35 rue Lemaire, 82522, Thibault",Canada
4,Mirabel Gruppo,"26 Ruiz Heights, 94666, Sant'Andrea Bagni",Italie
5,Jonsson Sillag,"1 Raiffeisenstrasse, 29661, Rodgau",Allemagne
6,Maison Docteur Martinez,"73 rue Renée Martinez, 20512, Lebreton-la-Forêt",France
7,Les laboratoires servier,"11 boulevard Marion, 28046, Marques",France
8,Boirâme,"63 chemin Didier, 33500, Collin",France
16,Icelandic Team of Research,"2 Jean alley, 67051, Hilvarenbeek",Islande
12,Centre de recherche cancérologie,"652 chemin de Tessier, 01027, Sainte FranckBourg",France
17,Computer Geomatics Datacenter,"32 Andrew Roads, TS46 2BT, South Clive",Etats-Unis
14,Quebec National Lab,"1 Stevens camp, 19159, Thomaston",Canada
15,Mexico Central Lab,"75 Jessica Freeway, R3G6G7, San Nicola Di Caulonia",Mexique
13,Laboratoire cosmétique,"79 boulevard de Evrard, 88100, Bertinnec",France
11,Laboratoire Thomas Legendre,"62 rue Legendre, 53174, Lamy",France
10,Centre MathieuVille,"87 rue Evrard, 88593, MathieuVille",France
\.

--
-- Data for Name: Revue
--

COPY revue FROM STDIN csv;
0,Alep,101,11
1,Catalonia,103,0
2,Prismi,107,5
3,Napis,111,12
4,Courrier René Descartes,106,2
5,Atlante,105,8
6,Cahiers Jean Moulin,113,3
7,Hybrid,111,8
8,Narrativa,100,6
9,Artefact,108,3
10,Les Annales,109,12
11,Via Kentron,102,7
12,Artelogie,110,7
13,Signata,114,0
14,La Revue commerce,115,11
15,"l'Hebdomadaire",114,1
16,Ad Machina,119,1
\.

--
-- Data for Name: article
--

COPY article FROM STDIN csv;
0,Perspective,Anglais,54,1999,X,0
1,Meteorology and Atmospheric Physics,Anglais,5,2014,III,11
2,Géomatique de la terre infinie,Français,8,2010,IV,12
3,La Météorologie,Français,40,2020,IV,12
4,Le code digital de lADN,Français,25,2019,VI,1
5,Neurochirurgie transplantaire,Français,3,2022,VIII,9
6,Studies in second language acquisition,Italien,2,1990,IV,0
7,Geoinformatica,Espagnol,21,2015,V,10
8,Web programming with Flask,Anglais,12,2017,III,13
9,Asthme et conséquences,Français,13,2001,VIII,0
10,LArchitecture dAujourdhui,Français,2,2020,IX,1
11,Scopus,Latin,6,2014,VII,7
12,La chimie pour les nuls,Français,9,2016,IV,3
13,Algorithmiques et espaces géométriques,Français,5,2021,VII,0
14,Guide complet des champignons,Français,8,2018,II,11
15,Sociologie égypte antique,Français,3,2005,III,2
16,Chimie organique et transplantations,Français,2,2008,I,5
17,Bases de données relationnelles,Français,9,2022,IX,2
18,Journal of Architecture,Allemand,17,1997,VIII,6
19,Agricultural Systems,Allemand,4,2002,III,1
20,ArtItalies,Italien,7,2010,I,6
21,Tachychardie supraventriculaire,Français,6,2010,II,8
22,Les Cahiers Agricultures,Français,8,2010,I,5
23,Web of Science,Islandais,4,2019,X,9
24,Journal of Artificial Organs,Anglais,7,2022,VII,0
25,"Dialektikê, cahiers de typologie analytique",Français,2,1997,X,14
26,Paléo,Français,2,2004,X,7
27,Cartographica,Allemand,9,2004,X,10
28,Gallia,Allemand,1,2004,VI,13
29,Architectural Design,Italien,7,2022,I,5
30,How to Agronomie,Chinois,143,1993,VIII,4
31,Chimie for beginners,Islandais,91,1991,I,13
32,Le Archéologie facile,Français,112,1994,VI,12
33,The Joy of Architecture,Arabe,243,1991,XII,8
34,Le mythe de Biologie,Anglais,115,1994,V,5
35,How to Archéologie,Espagnol,153,1989,VIII,10
36,Les secrets de Chimie,Espagnol,234,2023,XIV,3
37,Les secrets de Météorologie,Arabe,115,1999,XIII,16
38,Informatique for beginners,Islandais,14,2001,IX,4
39,How to Archéologie,Italien,119,1996,XV,14
40,Sociologie for beginners,Français,210,1986,III,11
41,"L'art de Histoire de lart",Arabe,20,1984,VI,8
42,Le Agronomie facile,Italien,83,2003,IX,7
43,Histoire de lart for beginners,Islandais,176,2022,V,15
44,"L'art de Linguistique",Français,227,1999,VII,14
45,Archéologie: 10 secrets simples,Français,192,2014,XIII,16
46,Les secrets de Sociologie,Anglais,109,1985,V,2
47,The Joy of Météorologie,Islandais,204,1986,XIV,13
48,"L'art de Sciences de la nature",Français,26,1999,I,4
49,The Joy of Chimie,Français,198,2001,XII,6
50,How to Médecine,Français,246,1987,IV,8
51,Le mythe de Géographie,Islandais,54,1983,II,6
52,Agronomie for beginners,Espagnol,97,2023,XII,15
53,Météorologie for beginners,Chinois,56,1999,VIII,7
54,The Joy of Histoire de lart,Français,65,2006,X,11
55,Informatique: 10 secrets simples,Islandais,136,2009,IV,11
56,Le mythe de Histoire de lart,Islandais,152,2012,IV,8
57,Le mythe de Histoire de lart,Islandais,12,2019,II,13
58,The Joy of Histoire de lart,Islandais,143,1989,XV,2
59,The Joy of Sociologie,Anglais,208,2009,V,4
60,How to Histoire de lart,Arabe,124,2006,XII,14
61,Sociologie for beginners,Chinois,27,2012,IX,14
62,"L'art de Géographie",Arabe,50,1995,XIV,0
63,Les secrets de Sciences de la nature,Espagnol,66,2000,I,16
64,Le Architecture facile,Norvégien,97,2012,VIII,9
65,The Joy of Histoire de lart,Italien,200,2014,XII,15
66,The Joy of Sciences de la nature,Islandais,99,2012,XVI,14
67,Les secrets de Météorologie,Arabe,201,2017,XI,12
68,Les secrets de Agronomie,Espagnol,179,1994,XVI,11
69,The Joy of Histoire de lart,Anglais,68,1982,VIII,11
70,Architecture: 10 secrets simples,Italien,103,1991,X,6
71,Le Agronomie facile,Espagnol,75,1993,VI,8
72,Architecture: 10 secrets simples,Français,126,1984,XIV,7
73,Les secrets de Biologie,Français,95,1982,VIII,0
74,Géographie for beginners,Norvégien,120,1998,II,3
75,Les secrets de Météorologie,Norvégien,193,1995,II,12
76,Le Biologie facile,Norvégien,84,1980,III,4
77,Biologie for beginners,Espagnol,242,1992,XVI,5
78,How to Architecture,Arabe,189,2022,XIV,15
79,Le Informatique facile,Anglais,92,2015,I,14
80,"L'art de Météorologie",Norvégien,197,1981,XIV,15
81,Les secrets de Chimie,Français,191,1990,II,10
82,How to Chimie,Anglais,233,2009,XII,8
83,The Joy of Sociologie,Français,240,1995,IV,0
84,Les secrets de Archéologie,Chinois,137,1982,XI,7
85,How to Médecine,Islandais,188,2019,XV,9
86,Le mythe de Informatique,Anglais,154,2022,XII,16
87,Le mythe de Histoire de lart,Espagnol,229,2002,IX,3
88,Architecture: 10 secrets simples,Français,41,2000,VI,10
89,How to Archéologie,Norvégien,149,1991,XV,4
90,How to Météorologie,Français,87,2022,X,11
91,"L'art de Architecture",Anglais,133,2011,XVI,7
92,Météorologie for beginners,Espagnol,247,1998,VI,6
93,Les secrets de Histoire de lart,Espagnol,84,2003,VII,7
94,Le Sociologie facile,Chinois,213,2022,II,13
95,Agronomie for beginners,Français,165,1993,III,11
96,Le Chimie facile,Anglais,112,2006,X,14
97,Biologie for beginners,Anglais,119,1994,I,9
98,The Joy of Histoire de lart,Arabe,27,2009,XII,14
99,Histoire de lart for beginners,Chinois,217,2013,XV,9
100,Architecture: 10 secrets simples,Arabe,99,1991,XII,8
101,Les secrets de Géographie,Chinois,212,1984,XV,0
102,Le mythe de Sociologie,Chinois,73,2013,XI,4
103,Le mythe de Météorologie,Français,129,1995,XIV,4
104,The Joy of Informatique,Norvégien,210,1981,XV,5
105,Les secrets de Géographie,Arabe,49,2002,XV,16
106,Archéologie: 10 secrets simples,Arabe,104,2016,VI,2
107,Les secrets de Géographie,Arabe,42,2004,I,12
108,Le mythe de Informatique,Français,138,2017,X,10
109,Le Histoire de lart facile,Anglais,125,2023,XIII,15
110,Le Chimie facile,Français,17,1997,III,11
111,Sociologie for beginners,Italien,53,2003,XVI,15
112,Sociologie for beginners,Italien,209,1987,III,12
113,Le Archéologie facile,Norvégien,235,1988,XV,12
114,Archéologie: 10 secrets simples,Italien,133,2000,IV,15
115,"L'art de Histoire de lart",Français,79,2020,X,6
116,Sciences de la nature for beginners,Français,247,1993,XI,2
117,The Joy of Architecture,Espagnol,123,1981,XIII,5
118,The Joy of Sociologie,Espagnol,211,1992,VI,3
119,Le mythe de Sciences de la nature,Français,182,2015,VI,5
120,Informatique: 10 secrets simples,Italien,233,1981,V,10
121,How to Météorologie,Espagnol,113,2000,XIII,12
122,"L'art de Sociologie",Norvégien,160,2004,VIII,4
123,Archéologie for beginners,Anglais,137,2013,X,0
124,Médecine for beginners,Chinois,201,1988,VIII,8
125,Les secrets de Archéologie,Italien,45,2005,III,11
126,How to Météorologie,Italien,86,2005,XI,6
127,Agronomie for beginners,Arabe,153,2007,XI,13
128,Médecine: 10 secrets simples,Norvégien,199,1985,XII,13
129,"L'art de Agronomie",Français,214,2014,I,5
130,Le mythe de Linguistique,Chinois,174,2013,VIII,15
131,Sociologie for beginners,Chinois,153,1984,IV,14
132,Le Géographie facile,Anglais,187,2017,V,8
133,Linguistique: 10 secrets simples,Norvégien,206,2007,XIV,6
134,The Joy of Météorologie,Chinois,109,1999,VIII,2
135,How to Chimie,Espagnol,244,2011,XV,5
136,Le mythe de Linguistique,Norvégien,38,1997,VI,1
137,The Joy of Sciences de la nature,Chinois,70,2021,XIV,11
138,Archéologie for beginners,Islandais,19,2018,VII,7
139,Le mythe de Sciences de la nature,Norvégien,247,1996,XVI,7
140,How to Géographie,Français,67,2013,IX,15
141,Le mythe de Météorologie,Français,83,2011,VII,15
142,Météorologie: 10 secrets simples,Arabe,240,1991,V,7
143,Le mythe de Sciences de la nature,Chinois,84,1981,XI,1
144,The Joy of Sciences de la nature,Chinois,11,2004,I,15
145,Le mythe de Agronomie,Arabe,100,2014,VII,10
146,Météorologie: 10 secrets simples,Anglais,229,2012,X,8
147,How to Linguistique,Norvégien,156,2006,XV,7
148,Géographie for beginners,Arabe,22,1996,II,15
149,Géographie: 10 secrets simples,Français,21,2003,XII,13
150,Les secrets de Sociologie,Italien,92,1993,XV,1
151,The Joy of Géographie,Espagnol,71,2014,IV,14
152,Sciences de la nature for beginners,Italien,50,1982,X,8
153,"L'art de Médecine",Français,236,2019,XIV,15
154,Le mythe de Chimie,Français,32,1991,XI,11
155,Le Météorologie facile,Norvégien,79,2005,III,8
156,Les secrets de Médecine,Espagnol,121,2000,XII,2
157,Le Sciences de la nature facile,Anglais,179,1984,IV,11
158,Le mythe de Sociologie,Anglais,72,2002,XIII,9
159,Le Informatique facile,Chinois,170,1982,VIII,16
160,Les secrets de Biologie,Arabe,190,1982,XI,4
161,Les secrets de Météorologie,Anglais,185,2010,IV,10
162,Architecture: 10 secrets simples,Islandais,18,2013,XIII,4
163,Le Archéologie facile,Français,38,2011,II,13
164,Les secrets de Informatique,Islandais,207,2023,VI,14
165,Histoire de lart: 10 secrets simples,Français,223,2011,IX,4
166,How to Biologie,Islandais,113,1981,XII,6
167,Le mythe de Agronomie,Français,136,2000,I,15
168,"L'art de Météorologie",Italien,249,2022,XIV,14
169,Le Informatique facile,Arabe,74,2002,XIII,9
170,Les secrets de Histoire de lart,Norvégien,179,1981,XV,7
171,The Joy of Archéologie,Islandais,164,2019,IV,16
172,Agronomie for beginners,Français,80,1993,VI,13
173,Le Biologie facile,Français,14,2011,IV,0
174,Les secrets de Informatique,Arabe,49,2011,XIV,11
175,Les secrets de Sciences de la nature,Français,183,2005,I,10
176,Les secrets de Géographie,Français,129,2012,XIII,0
177,"L'art de Météorologie",Italien,242,1984,X,15
178,Le Architecture facile,Espagnol,114,1996,II,16
179,The Joy of Météorologie,Anglais,64,1981,XIII,14
180,Les secrets de Sciences de la nature,Français,199,2011,XI,10
181,Les secrets de Sociologie,Français,8,1999,VI,2
182,Les secrets de Géographie,Arabe,45,1988,V,2
183,Géographie: 10 secrets simples,Islandais,118,2011,II,3
184,Les secrets de Agronomie,Islandais,215,2001,XI,5
185,Médecine: 10 secrets simples,Islandais,17,2012,XII,14
186,Les secrets de Agronomie,Chinois,9,2016,VIII,8
187,Chimie: 10 secrets simples,Français,162,1989,VIII,16
188,"L'art de Architecture",Espagnol,212,2021,XIII,16
189,"L'art de Informatique",Espagnol,232,2020,VII,10
190,Les secrets de Météorologie,Espagnol,117,1982,XV,9
191,"L'art de Informatique",Italien,44,2012,XII,5
192,Le mythe de Informatique,Norvégien,168,2021,VIII,7
193,Les secrets de Sciences de la nature,Islandais,52,1983,XII,11
194,The Joy of Géographie,Anglais,227,2005,XIII,12
195,Le mythe de Architecture,Anglais,93,2020,I,1
196,Les secrets de Géographie,Islandais,193,2014,V,15
197,Architecture: 10 secrets simples,Chinois,217,2020,XIV,9
198,"L'art de Sciences de la nature",Français,21,2012,IX,14
199,Archéologie for beginners,Norvégien,105,1985,XVI,8
200,The Joy of Sciences de la nature,Chinois,240,1991,IX,4
\.

--
-- Data for Name: domaine
--

COPY domaine FROM STDIN csv;
Archéologie
Architecture
Géographie
Histoire de lart
Linguistique
Sciences de la nature
Agronomie
Biologie
Informatique
Chimie
Météorologie
Sociologie
Médecine
\.

--
-- Data for Name: Auteur
--

COPY auteur FROM STDIN csv;
0,Poissenot,Irma,0894682547,11
1,Manacorda,Livio,0675886147,6
2,Bejot,Vincent,0519398428,3
3,Frechin,Hortense,0498528677,9
4,Stumpf,Marlon,0439377249,4
5,Grassi,Cheryl,0994452187,9
6,Rebuffel,Solen,0593227777,4
7,Angele,Maximilian,0381296258,12
8,Farcy,Appolonie,0174959193,2
9,Trüb,Nathalie,0897999798,8
10,Naranjo,Iris,0178148241,6
11,Croizer,Kalvin,0489487673,10
12,Hivert,Paola,0441471686,7
13,Harmon,Thomas,0814424255,0
14,Garret,Niek,0975917937,1
15,Schleich,Bert,0625781931,9
16,Moura,Majid,0314613425,7
17,Granat,Irvin,0653254972,7
18,Lopez,Matthew,0221189152,12
19,Gaveau,Anne-Lise,0524392363,11
20,Desmaison,Melika,0385573711,8
21,Robinson,Melissa,0622727296,10
22,Toulemonde,Vera,0347476288,0
23,Doat,Joachim,0542728342,9
24,Taylor-Dyer,Simon,0815354281,6
25,Bonaldi,Marie-Laurence,0439523178,3
26,van,Meike,0395568592,11
27,Vignot,Alexine,0512453719,13
28,Corpet,Eymen,0268748113,3
29,Holveck,Janna,0171265849,6
30,Blanchard,Patrick,0465685387,5
31,Barbera,Tania,0266579343,1
32,Goulois,Tristan,0129937698,7
33,Bonnardel,Agatha,0262983612,0
34,Roberts,Eric,0993622388,0
35,Mariage,Ronan,0782742165,1
36,Offroy,Janie,0751291145,13
37,Raquin,Scott,0732586691,3
38,Le,Gabryel,0228625633,8
39,Howells,Adam,0976678127,8
40,Sharp,Bradley,0166968935,4
41,Vieira,Smain,0483591841,10
42,Fargette,Natasha,0272366118,13
43,Perez,Andrew,0751851521,9
44,Barber,Paul,0934467193,0
45,Balan,Kaylan,0664836341,3
46,Bonetto,Marie-Claire,0591871445,11
47,Piget,Diego,0965669627,7
48,Gabard,Sadio,0899493872,0
49,Brechet,Joyce,0441935419,0
50,Casellati,Claudio,0647281386,12
51,Augendre,Antoinette,0672739695,11
52,Toninelli-Donati,Bianca,0952913929,5
53,Lee,Jordan,0633326475,12
54,Rocamora,Pía,0112624557,12
55,Toninelli-Donati,Bianca,0736666125,3
56,Kopec,Marie-Joëlle,0573863828,9
57,Rojas,Bryan,0482635772,8
58,Hill,Antony,0978489775,11
59,Löchel-Henschel,August,0736531678,10
60,Solis,Felipe,0183777245,2
61,Gras,Federico,0888772644,6
62,Weimer,Josefa,0362175623,7
63,Hemma,Zakaria,0112624557,0
64,Hemma,Zakaria,0183777245,11
65,Serna,Kelyan,0766788917,0
66,Buck,Michael,0438463514,4
67,Casellati,Claudio,0736666125,10
68,Hantz,Juan,0713656832,4
69,Rocamora,Pía,0482635772,6
70,Bernal,Amor,0769316514,9
71,Boche,Burak,0573518824,1
72,Butte,Liesel,0573863828,10
73,Dante,Dott.,0633326475,9
74,Bligny,Claire-Marie,0736531678,4
75,Cook,Jessica,0112624557,9
76,Dodson,Stephanie,0654636534,2
77,Plessy,Lucas,0899134476,5
78,Verne,Ilyess,0461572724,13
79,Luís,Juan,0438463514,13
80,Barray,Swan,0482635772,7
81,Guitart,Tamara,0878992277,9
82,Luís,Juan,0468398782,3
83,Rojas,Bryan,0763815943,9
84,Anderson,Richard,0482635772,8
85,Nigel,Mr,0692383684,2
86,Campo,Ámbar,0444463287,3
87,Dante,Dott.,0622267721,4
88,Buck,Michael,0845315384,12
89,Houbart,Anne-Lyse,0438463514,6
90,van,Angelina,0423929491,5
91,Joel,Dr,0455835865,12
92,Pons,Salud,0973452573,2
93,Klapp,Horst-Günter,0553811662,3
94,Zito,Jolanda,0442427867,5
95,Buck,Michael,0935991246,11
96,Reboul,Adame,0973452573,0
97,Hall,Jeremy,0144992673,8
98,Bouteloup,Maéva,0663941172,1
99,Knuf,Pepijn,0633326475,10
100,Lopez,Jonathan,0455835865,1
101,Gras,Federico,0794294852,1
102,Allen,Tyler,0482635772,3
103,Kervarrec,Roland,0341699111,3
104,Cantrel,Ruben,0499269633,5
105,Janneau,Sherazade,0591347785,13
106,Kurt,Loann,0283623395,0
107,Saumon,Nawfel,0874218433,3
108,Villanova,Thalia,0458593371,5
109,Melo,Oceane,0524913235,4
110,Villanova,Thalia,0827413317,2
111,Matos,Chainez,0874218433,8
112,Barnay,Mariama,0889185412,9
113,Cantrel,Ruben,0927811362,3
114,Poussin,Jorge,0273482624,12
115,Gras,Salvador,0114214325,2
116,Fichaux,Marie-Pascale,0538726882,3
117,Gras,Salvador,0537878519,2
118,Gresse,Coraly,0538726882,13
119,Rabillard,Cristelle,0186357632,7
120,Bastard,Anne-Elisabeth,0183595981,12
121,Nadot,Fatiha,0653655194,9
122,Cojean,Jeromine,0671662541,12
123,Cornou,Thélio,0954471337,8
124,Buge,Norah,0471957277,1
125,Mazzi,Gaetano,0369587579,9
126,Perea,Yazid,0664171935,4
127,Blois,Cosette,0557369741,1
128,Voirin,Yousri,0538726882,6
129,Decottignies,Mayssane,0341699111,1
130,Vanessa,Dr,0874218433,11
131,Cornou,Thélio,0263419149,7
132,Baconnais,Mamoudou,0578738881,0
133,Terrien,Anael,0555597988,7
134,Luna,Sergius,0726552312,1
135,Fougeray,Lilia,0548577361,10
136,Belloy,Pierre-François,0446612422,0
137,Dias,Dani,0344854494,5
138,Brel,Mallorie,0827413317,11
139,Toulze,Ahmad,0447111844,12
140,Becher,Marie-Lou,0245476455,9
141,Virin,Janny,0653655194,1
142,Canac,Claude,0841138757,10
143,Poussin,Jorge,0637647491,9
144,Laroque,Clementine,0447111844,10
145,Saulnier,Pascaline,0261617313,13
146,Jones,Amy,0557369741,6
147,Wall-Pearson,Maureen,0283623395,12
148,Pluchart,Sidonie,0578738881,1
149,Fichaux,Marie-Pascale,0484847534,11
150,Dias,Dani,0591347785,11
151,Berdin,Goulven,0886832673,6
152,Brown,Lucas,0263419149,10
153,Buge,Norah,0915476433,12
154,Saumon,Nawfel,0698529133,0
155,Asmundo,Manuel,0338617922,1
156,Cadefau,Sam,0313515925,8
157,Le,Maëva,0522614434,1
158,Dias,Dani,0186357632,1
159,Gaussens,Nathanael,0841138757,11
160,Baeza,Archibald,0564774513,0
161,Montanari,Byron,0229752222,1
162,Desmazieres,Zia,0237693577,7
163,Melo,Oceane,0915476433,5
164,Fichaux,Marie-Pascale,0388284296,9
165,Sallaberry,Nabil,0633182899,2
166,Tendron,Jihane,0522614434,4
167,Falck,Calypso,0664171935,9
168,Perray,Stan,0578738881,12
169,Rabillard,Cristelle,0344854494,2
170,Terrien,Anael,0283623395,3
171,Fuhrmann,Josseline,0518179811,4
172,Ricci,Luigina,0564761512,13
173,Montanari,Byron,0319143917,6
174,Gentet,Amal,0578738881,5
175,Pinat,Noa,0524913235,3
176,Kermorvant,Francette,0325187283,0
177,Delaplace,Nahim,0196197716,4
178,Janneau,Sherazade,0927811362,1
179,Kelley,Charles,0954197691,2
180,Peran,Romuald,0369817243,3
\.

--
-- Data for Name: affilie
--

COPY affilie FROM STDIN csv;
0,30,1
1,19,5
2,39,1
3,6,5
4,20,1
5,32,7
6,41,8
7,26,8
8,44,1
9,45,6
10,6,3
11,24,4
12,7,7
13,41,7
14,39,5
15,0,5
16,1,4
17,21,7
18,20,5
19,6,6
20,10,3
21,30,3
22,35,8
23,25,3
24,19,8
25,26,8
26,47,0
27,2,2
28,0,1
29,13,6
30,141,12
31,179,8
32,133,8
33,100,14
34,45,14
35,148,11
36,170,13
37,93,12
38,50,13
39,153,10
40,81,10
41,101,13
42,112,10
43,104,15
44,121,14
45,176,15
46,163,8
47,52,15
48,162,15
49,126,14
50,82,15
51,102,10
52,72,10
53,97,10
54,55,12
55,172,14
56,142,10
57,151,8
58,103,10
59,178,14
60,102,8
61,65,10
62,74,12
63,47,13
64,62,10
65,140,15
66,70,13
67,49,10
68,64,12
69,109,15
70,63,10
71,145,14
72,130,11
73,92,12
74,50,15
75,149,13
76,81,8
77,109,12
78,165,12
79,87,8
80,137,8
81,87,13
82,102,10
83,156,11
84,56,10
85,79,10
86,70,15
87,84,10
88,179,10
89,175,10
90,89,8
91,173,10
92,113,12
93,49,12
94,53,14
95,118,12
96,109,12
97,167,11
98,65,12
99,125,12
100,94,10
101,97,14
102,80,11
103,153,10
104,64,15
105,147,12
106,145,14
107,86,8
108,77,15
109,155,15
110,111,14
111,97,12
112,165,15
113,162,8
114,124,10
115,144,15
116,91,15
117,110,8
118,116,11
119,130,10
120,135,11
121,98,8
122,133,12
123,120,8
124,108,13
125,78,14
126,68,14
127,130,14
128,68,10
129,180,14
130,137,11
131,138,8
132,71,12
133,105,13
134,58,13
135,72,11
136,174,15
137,131,12
138,58,15
139,150,14
140,93,13
141,104,8
142,160,11
143,143,8
144,82,14
145,130,15
146,165,8
147,113,12
148,130,11
149,135,11
150,131,15
151,52,10
152,51,11
153,49,13
154,81,10
155,90,10
156,118,15
157,163,14
158,167,15
159,45,10
160,59,11
161,86,11
162,38,15
163,50,8
164,57,10
165,60,10
166,101,11
167,117,15
168,91,10
169,87,10
170,56,14
171,171,15
172,122,14
173,64,8
174,110,8
175,135,12
176,85,13
177,105,10
178,76,14
179,110,14
180,143,15
181,69,11
182,99,13
183,121,8
184,69,15
185,47,15
186,112,15
187,40,12
188,148,15
189,106,11
190,163,15
191,55,8
192,112,12
193,67,12
194,95,10
195,128,10
196,39,13
197,53,10
198,167,10
199,179,8
200,155,11
\.

--
-- Data for Name: appartient
--

COPY appartient FROM STDIN csv;
0,Architecture
1,Météorologie
2,Géographie
3,Météorologie
4,Biologie
4,Médecine
5,Médecine
6,Linguistique
7,Géographie
8,Informatique
9,Médecine
10,Architecture
11,Histoire de lart
12,Chimie
12,Biologie
13,Informatique
14,Sciences de la nature
15,Sociologie
16,Chimie
17,Informatique
18,Architecture
18,Histoire de lart
19,Agronomie
20,Histoire de lart
21,Médecine
22,Agronomie
23,Sciences de la nature
24,Médecine
25,Archéologie
26,Archéologie
27,Géographie
28,Histoire de lart
29,Architecture
30,Agronomie
31,Chimie
32,Archéologie
33,Architecture
34,Biologie
35,Archéologie
36,Chimie
37,Météorologie
38,Informatique
39,Archéologie
40,Sociologie
41,Histoire de lart
42,Agronomie
43,Histoire de lart
44,Linguistique
45,Archéologie
46,Sociologie
47,Météorologie
48,Sciences de la nature
49,Chimie
50,Médecine
51,Géographie
52,Agronomie
53,Météorologie
54,Histoire de lart
55,Informatique
56,Histoire de lart
57,Histoire de lart
58,Histoire de lart
59,Sociologie
60,Histoire de lart
61,Sociologie
62,Géographie
63,Sciences de la nature
64,Architecture
65,Histoire de lart
66,Sciences de la nature
67,Météorologie
68,Agronomie
69,Histoire de lart
70,Architecture
71,Agronomie
72,Architecture
73,Biologie
74,Géographie
75,Météorologie
76,Biologie
77,Biologie
78,Architecture
79,Informatique
80,Météorologie
81,Chimie
82,Chimie
83,Sociologie
84,Archéologie
85,Médecine
86,Informatique
87,Histoire de lart
88,Architecture
89,Archéologie
90,Météorologie
91,Architecture
92,Météorologie
93,Histoire de lart
94,Sociologie
95,Agronomie
96,Chimie
97,Biologie
98,Histoire de lart
99,Histoire de lart
100,Architecture
101,Géographie
102,Sociologie
103,Météorologie
104,Informatique
105,Géographie
106,Archéologie
107,Géographie
108,Informatique
109,Histoire de lart
110,Chimie
111,Sociologie
112,Sociologie
113,Archéologie
114,Archéologie
115,Histoire de lart
116,Sciences de la nature
117,Architecture
118,Sociologie
119,Sciences de la nature
120,Informatique
121,Météorologie
122,Sociologie
123,Archéologie
124,Médecine
125,Archéologie
126,Météorologie
127,Agronomie
128,Médecine
129,Agronomie
130,Linguistique
131,Sociologie
132,Géographie
133,Linguistique
134,Météorologie
135,Chimie
136,Linguistique
137,Sciences de la nature
138,Archéologie
139,Sciences de la nature
140,Géographie
141,Météorologie
142,Météorologie
143,Sciences de la nature
144,Sciences de la nature
145,Agronomie
146,Météorologie
147,Linguistique
148,Géographie
149,Géographie
150,Sociologie
151,Géographie
152,Sciences de la nature
153,Médecine
154,Chimie
155,Météorologie
156,Médecine
157,Sciences de la nature
158,Sociologie
159,Informatique
160,Biologie
161,Météorologie
162,Architecture
163,Archéologie
164,Informatique
165,Histoire de lart
166,Biologie
167,Agronomie
168,Météorologie
169,Informatique
170,Histoire de lart
171,Archéologie
172,Agronomie
173,Biologie
174,Informatique
175,Sciences de la nature
176,Géographie
177,Météorologie
178,Architecture
179,Météorologie
180,Sciences de la nature
181,Sociologie
182,Géographie
183,Géographie
184,Agronomie
185,Médecine
186,Agronomie
187,Chimie
188,Architecture
189,Informatique
190,Météorologie
191,Informatique
192,Informatique
193,Sciences de la nature
194,Géographie
195,Architecture
196,Géographie
197,Architecture
198,Sciences de la nature
199,Archéologie
200,Sciences de la nature
\.

--
-- Data for Name : cite
--

COPY cite FROM STDIN csv;
4, 24
28, 20
4, 16
25, 26
29, 0
6, 15
16, 4
16, 5
16, 24
27,156
91,111
108,26
114,31
68,198
199,15
94,138
129,16
178,99
85,113
105,166
180,90
111,87
197,28
153,69
181,36
65,29
62,150
137,35
21,58
143,120
153,176
160,91
113,65
145,159
81,114
80,159
95,173
62,23
45,149
132,38
2,126
58,43
95,185
68,95
72,13
112,175
6,145
25,171
101,185
129,140
54,41
131,121
45,50
131,137
37,91
8,47
74,15
64,146
33,163
106,29
38,141
167,39
100,145
115,16
66,176
158,133
0,190
190,25
33,194
120,48
118,48
176,131
176,29
138,74
107,163
96,138
39,35
24,98
143,127
82,30
154,182
108,154
93,75
48,75
99,180
198,127
97,73
151,111
94,188
57,155
118,11
109,196
116,148
162,187
184,0
118,47
24,107
199,85
75,83
77,38
35,163
2,198
10,102
2,153
45,154
136,130
101,171
15,93
82,124
92,144
148,40
195,139
179,161
123,170
31,150
84,172
59,18
112,109
141,69
90,25
31,58
82,111
147,29
129,142
124,61
30,120
151,156
149,174
192,29
85,80
70,132
115,3
127,184
108,66
47,69
168,8
186,91
48,63
95,171
46,130
192,154
149,121
83,198
1,66
27,86
19,54
73,121
151,93
163,22
100,197
86,104
20,67
6,69
6,177
198,30
176,125
80,53
20,94
101,154
151,62
40,80
182,86
145,150
151,177
23,156
90,147
136,70
122,122
118,91
18,155
47,89
11,13
141,151
15,148
19,166
133,171
120,7
10,144
17,185
4,32
120,126
140,161
174,115
118,39
70,24
88,124
73,161
34,19
182,8
114,65
171,131
11,2
67,70
161,25
123,144
65,196
33,58
101,16
108,25
176,183
112,115
81,169
123,188
14,148
70,107
71,22
81,103
94,126
101,87
98,133
30,76
88,76
58,76
143,76
152,76
18,76
92,76
16,76
36,76
61,76
122,76
89,76
183,76
7,76
75,76
121,76
34,76
108,76
19,76
171,76
200,76
40,76
54,76
10,76
145,76
32,76
74,76
112,76
173,76
5,76
17,76
114,76
13,76
70,76
12,76
15,76
82,76
99,76
63,76
150,76
83,76
29,76
9,76
106,76
26,76
148,76
149,76
103,76
164,76
43,76
71,76
115,76
73,76
85,76
154,76
105,76
198,76
78,76
133,76
175,76
95,76
187,76
107,76
177,76
167,76
49,76
159,76
3,76
196,76
35,76
127,76
20,76
178,76
60,76
128,76
129,76
124,76
125,76
110,76
139,76
102,76
64,76
147,76
142,76
138,76
170,76
161,76
28,76
72,76
166,76
136,76
23,76
22,76
44,76
33,76
80,76
100,76
120,76
191,76
98,76
126,76
47,76
50,76
42,76
77,76
96,76
2,76
59,76
116,76
189,76
39,76
66,76
51,76
158,76
31,76
132,76
162,76
190,76
101,76
119,76
25,76
109,76
46,76
117,76
57,76
188,76
113,76
94,76
68,76
130,76
52,76
48,76
55,76
195,76
41,76
45,76
194,76
93,76
38,76
131,76
172,76
157,76
27,76
84,76
176,76
14,76
155,76
53,76
135,76
160,76
118,76
184,76
1,76
21,76
168,76
182,76
134,76
56,76
0,76
86,76
197,76
153,76
123,76
174,76
91,76
169,76
90,76
24,76
180,76
104,76
67,76
37,76
11,76
87,76
146,76
81,76
4,76
141,76
65,76
185,76
192,76
179,76
163,76
97,76
137,76
79,76
199,76
186,76
140,76
165,76
193,76
69,76
111,76
181,76
6,76
144,76
156,76
151,76
8,76
62,76
\.


-- ADMINS

INSERT INTO admins(nom_utilisateur, mdp) VALUES('admin', '$2b$12$J4aTbk1a2N0wy9Wk/MOzBemw0NGBX.U6C3kYmTxqEtFN4zid4M8Eu');

-- VUES --

-- QUESTION 3 --

Create VIEW aut_nb_article as 
(
Select id_auteur, count(id_art) as nb_art from affilie
group by id_auteur
Order by nb_art DESC
limit 5
);

CREATE VIEW labo_nb_article AS
(
Select  id_labo, count(id_art) as nb_art from affilie
group by id_labo
Order by nb_art DESC
limit 5
);

-- QUESTION 2 --

CREATE VIEW art_cite_100 as
(
Select id_art_cite from cite,article
where cite.id_art_cite = article.id_art
and annee between annee and annee + 2
group by id_art_cite
having (count(cite.id_art) > 100)
);

-- QUESTION 3 --
-- Ne marche pas --

CREATE VIEW taux_pub_revue AS
(
Select nom_domaine, 100*nb_art/sum(nb_art) as taux from 
(
    Select count(id_art) as nb_art, nom_domaine from appartient
    group by nom_domaine
) as t
group by nb_art, nom_domaine
);