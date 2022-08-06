PGDMP                         z         
   Projeto-BD    14.4    14.4 w    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    49152 
   Projeto-BD    DATABASE     l   CREATE DATABASE "Projeto-BD" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Portuguese_Brazil.1252';
    DROP DATABASE "Projeto-BD";
                postgres    false            �            1255    49154    checkemprestimopendencia()    FUNCTION     T  CREATE FUNCTION public.checkemprestimopendencia() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN IF
        (SELECT COUNT(*) AS pendencia_count 
                FROM ((SELECT e.codigo_usuario
                            FROM emprestimo e
                            FULL JOIN devolucao d ON d.codigo_emprestimo = e.codigo_emprestimo
                            WHERE e.data_emprestimo = CURRENT_DATE)
                        INTERSECT
                        (SELECT e.codigo_usuario
                            FROM emprestimo e
                            FULL JOIN devolucao d ON d.codigo_emprestimo = e.codigo_emprestimo
                            WHERE e.data_final < CURRENT_DATE
                            AND d.data_devolucao is NULL)) AS foo) > 0
    THEN RAISE EXCEPTION 'Atraso pendente identificado.';
    END IF; RETURN NEW; END$$;
 1   DROP FUNCTION public.checkemprestimopendencia();
       public          postgres    false            �            1255    49155    deletecategoriasubordinada()    FUNCTION       CREATE FUNCTION public.deletecategoriasubordinada() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM categoria_subordinada
    WHERE codigo_super_categoria = OLD.codigo_categoria
    OR codigo_sub_categoria = OLD.codigo_categoria;
    RETURN OLD;
END;
$$;
 3   DROP FUNCTION public.deletecategoriasubordinada();
       public          postgres    false            �            1255    49156    deletelivroexemplar()    FUNCTION       CREATE FUNCTION public.deletelivroexemplar() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM exemplar
    WHERE codigo_exemplar IN 
        (SELECT codigo_exemplar 
         FROM exemplar
         WHERE isbn = OLD.isbn);
    RETURN NULL;
END;
$$;
 ,   DROP FUNCTION public.deletelivroexemplar();
       public          postgres    false            �            1255    49157    setnullemprestimoexemplar()    FUNCTION     C  CREATE FUNCTION public.setnullemprestimoexemplar() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE emprestimo
    SET codigo_exemplar = NULL
    WHERE codigo_exemplar IN
        (SELECT codigo_exemplar 
         FROM exemplar
         WHERE codigo_exemplar = OLD.codigo_exemplar);
    RETURN NULL;
END;
$$;
 2   DROP FUNCTION public.setnullemprestimoexemplar();
       public          postgres    false            �            1259    49158    autor    TABLE     b   CREATE TABLE public.autor (
    codigo_autor integer NOT NULL,
    nome character varying(255)
);
    DROP TABLE public.autor;
       public         heap    postgres    false            �            1259    49163    autor_codigo_autor_seq    SEQUENCE     �   CREATE SEQUENCE public.autor_codigo_autor_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.autor_codigo_autor_seq;
       public          postgres    false    209            �           0    0    autor_codigo_autor_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.autor_codigo_autor_seq OWNED BY public.autor.codigo_autor;
          public          postgres    false    210            �            1259    49164    bibliotecario    TABLE     �   CREATE TABLE public.bibliotecario (
    codigo_bibliotecario integer NOT NULL,
    nome character varying(255),
    rg character(12),
    cpf character(14),
    nascimento date,
    telefone character varying[],
    email character varying(100)
);
 !   DROP TABLE public.bibliotecario;
       public         heap    postgres    false            �            1259    49169    bibliotecario_codigo_seq    SEQUENCE     �   CREATE SEQUENCE public.bibliotecario_codigo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.bibliotecario_codigo_seq;
       public          postgres    false    211            �           0    0    bibliotecario_codigo_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public.bibliotecario_codigo_seq OWNED BY public.bibliotecario.codigo_bibliotecario;
          public          postgres    false    212            �            1259    49170 	   categoria    TABLE     j   CREATE TABLE public.categoria (
    codigo_categoria integer NOT NULL,
    nome character varying(255)
);
    DROP TABLE public.categoria;
       public         heap    postgres    false            �            1259    49175    categoria_codigo_categoria_seq    SEQUENCE     �   CREATE SEQUENCE public.categoria_codigo_categoria_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public.categoria_codigo_categoria_seq;
       public          postgres    false    213            �           0    0    categoria_codigo_categoria_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public.categoria_codigo_categoria_seq OWNED BY public.categoria.codigo_categoria;
          public          postgres    false    214            �            1259    49176    categoria_subordinada    TABLE     �   CREATE TABLE public.categoria_subordinada (
    codigo_super_categoria integer NOT NULL,
    codigo_sub_categoria integer NOT NULL
);
 )   DROP TABLE public.categoria_subordinada;
       public         heap    postgres    false            �            1259    49179 	   devolucao    TABLE        CREATE TABLE public.devolucao (
    codigo_devolucao integer NOT NULL,
    data_devolucao date DEFAULT CURRENT_DATE,
    hora_devolucao time without time zone DEFAULT CURRENT_TIMESTAMP(0),
    codigo_emprestimo integer,
    codigo_bibliotecario integer
);
    DROP TABLE public.devolucao;
       public         heap    postgres    false            �            1259    49184    devolucao_codigo_devolucao_seq    SEQUENCE     �   CREATE SEQUENCE public.devolucao_codigo_devolucao_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public.devolucao_codigo_devolucao_seq;
       public          postgres    false    216            �           0    0    devolucao_codigo_devolucao_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public.devolucao_codigo_devolucao_seq OWNED BY public.devolucao.codigo_devolucao;
          public          postgres    false    217            �            1259    49185    editora    TABLE     f   CREATE TABLE public.editora (
    codigo_editora integer NOT NULL,
    nome character varying(255)
);
    DROP TABLE public.editora;
       public         heap    postgres    false            �            1259    49190    editora_codigo_editora_seq    SEQUENCE     �   CREATE SEQUENCE public.editora_codigo_editora_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.editora_codigo_editora_seq;
       public          postgres    false    218            �           0    0    editora_codigo_editora_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.editora_codigo_editora_seq OWNED BY public.editora.codigo_editora;
          public          postgres    false    219            �            1259    49191 
   emprestimo    TABLE     O  CREATE TABLE public.emprestimo (
    codigo_emprestimo integer NOT NULL,
    data_emprestimo date DEFAULT CURRENT_DATE,
    hora_emprestimo time without time zone DEFAULT CURRENT_TIMESTAMP(0),
    codigo_usuario integer,
    codigo_bibliotecario integer,
    codigo_exemplar integer,
    data_final date DEFAULT (CURRENT_DATE + 10)
);
    DROP TABLE public.emprestimo;
       public         heap    postgres    false            �            1259    49197     emprestimo_codigo_emprestimo_seq    SEQUENCE     �   CREATE SEQUENCE public.emprestimo_codigo_emprestimo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 7   DROP SEQUENCE public.emprestimo_codigo_emprestimo_seq;
       public          postgres    false    220            �           0    0     emprestimo_codigo_emprestimo_seq    SEQUENCE OWNED BY     e   ALTER SEQUENCE public.emprestimo_codigo_emprestimo_seq OWNED BY public.emprestimo.codigo_emprestimo;
          public          postgres    false    221            �            1259    49198    endereco_bibliotecario    TABLE     �  CREATE TABLE public.endereco_bibliotecario (
    codigo_endereco_bibliotecario integer NOT NULL,
    codigo_bibliotecario integer NOT NULL,
    rotulo character varying(50),
    logradouro character varying(150),
    numero integer,
    complemento character varying(50),
    bairro character varying(50),
    cidade character varying(50),
    estado character varying(2),
    cep character varying(10)
);
 *   DROP TABLE public.endereco_bibliotecario;
       public         heap    postgres    false            �            1259    49204    endereco_usuario    TABLE     |  CREATE TABLE public.endereco_usuario (
    codigo_endereco_usuario integer NOT NULL,
    codigo_usuario integer NOT NULL,
    rotulo character varying(50),
    logradouro character varying(150),
    numero integer,
    complemento character varying(50),
    bairro character varying(50),
    cidade character varying(50),
    estado character varying(2),
    cep character(10)
);
 $   DROP TABLE public.endereco_usuario;
       public         heap    postgres    false            �            1259    49210    estante    TABLE     i   CREATE TABLE public.estante (
    codigo_estante integer NOT NULL,
    "Local" character varying(255)
);
    DROP TABLE public.estante;
       public         heap    postgres    false            �            1259    49215    estante_codigo_estante_seq    SEQUENCE     �   CREATE SEQUENCE public.estante_codigo_estante_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.estante_codigo_estante_seq;
       public          postgres    false    224            �           0    0    estante_codigo_estante_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.estante_codigo_estante_seq OWNED BY public.estante.codigo_estante;
          public          postgres    false    225            �            1259    49216    estante_secao    TABLE     n   CREATE TABLE public.estante_secao (
    codigo_estante integer NOT NULL,
    codigo_secao integer NOT NULL
);
 !   DROP TABLE public.estante_secao;
       public         heap    postgres    false            �            1259    49219    exemplar    TABLE     �   CREATE TABLE public.exemplar (
    codigo_exemplar integer NOT NULL,
    data_aquisicao date,
    descricao character varying(255),
    isbn bigint
);
    DROP TABLE public.exemplar;
       public         heap    postgres    false            �            1259    49224    exemplar_codigo_exemplar_seq    SEQUENCE     �   CREATE SEQUENCE public.exemplar_codigo_exemplar_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.exemplar_codigo_exemplar_seq;
       public          postgres    false    227            �           0    0    exemplar_codigo_exemplar_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public.exemplar_codigo_exemplar_seq OWNED BY public.exemplar.codigo_exemplar;
          public          postgres    false    228            �            1259    49225    livro    TABLE       CREATE TABLE public.livro (
    isbn bigint NOT NULL,
    palavras_chave character varying(100)[],
    data_publicacao date,
    titulo character varying(255),
    codigo_editora integer,
    codigo_categoria integer,
    idioma character varying(5),
    codigo_autor integer
);
    DROP TABLE public.livro;
       public         heap    postgres    false            �            1259    49230    multa    TABLE     �   CREATE TABLE public.multa (
    codigo_multa integer NOT NULL,
    dias_atraso integer,
    valor money,
    data_pagamento date,
    hora_pagamento time without time zone,
    codigo_emprestimo integer,
    codigo_bibliotecario integer
);
    DROP TABLE public.multa;
       public         heap    postgres    false            �            1259    49233    multa_codigo_multa_seq    SEQUENCE     �   CREATE SEQUENCE public.multa_codigo_multa_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.multa_codigo_multa_seq;
       public          postgres    false    230            �           0    0    multa_codigo_multa_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.multa_codigo_multa_seq OWNED BY public.multa.codigo_multa;
          public          postgres    false    231            �            1259    49234    secao    TABLE     b   CREATE TABLE public.secao (
    codigo_secao integer NOT NULL,
    nome character varying(255)
);
    DROP TABLE public.secao;
       public         heap    postgres    false            �            1259    49239    secao_codigo_secao_seq    SEQUENCE     �   CREATE SEQUENCE public.secao_codigo_secao_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.secao_codigo_secao_seq;
       public          postgres    false    232            �           0    0    secao_codigo_secao_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.secao_codigo_secao_seq OWNED BY public.secao.codigo_secao;
          public          postgres    false    233            �            1259    49240    usuario    TABLE     �   CREATE TABLE public.usuario (
    codigo_usuario integer NOT NULL,
    nome character varying(255),
    nascimento date,
    rg character varying(12),
    cpf character varying(14),
    telefone character varying[],
    email character varying(100)
);
    DROP TABLE public.usuario;
       public         heap    postgres    false            �            1259    49245    usuario_codigo_seq    SEQUENCE     �   CREATE SEQUENCE public.usuario_codigo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.usuario_codigo_seq;
       public          postgres    false    234            �           0    0    usuario_codigo_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.usuario_codigo_seq OWNED BY public.usuario.codigo_usuario;
          public          postgres    false    235            �           2604    49246    autor codigo_autor    DEFAULT     x   ALTER TABLE ONLY public.autor ALTER COLUMN codigo_autor SET DEFAULT nextval('public.autor_codigo_autor_seq'::regclass);
 A   ALTER TABLE public.autor ALTER COLUMN codigo_autor DROP DEFAULT;
       public          postgres    false    210    209            �           2604    49247 "   bibliotecario codigo_bibliotecario    DEFAULT     �   ALTER TABLE ONLY public.bibliotecario ALTER COLUMN codigo_bibliotecario SET DEFAULT nextval('public.bibliotecario_codigo_seq'::regclass);
 Q   ALTER TABLE public.bibliotecario ALTER COLUMN codigo_bibliotecario DROP DEFAULT;
       public          postgres    false    212    211            �           2604    49248    categoria codigo_categoria    DEFAULT     �   ALTER TABLE ONLY public.categoria ALTER COLUMN codigo_categoria SET DEFAULT nextval('public.categoria_codigo_categoria_seq'::regclass);
 I   ALTER TABLE public.categoria ALTER COLUMN codigo_categoria DROP DEFAULT;
       public          postgres    false    214    213            �           2604    49249    devolucao codigo_devolucao    DEFAULT     �   ALTER TABLE ONLY public.devolucao ALTER COLUMN codigo_devolucao SET DEFAULT nextval('public.devolucao_codigo_devolucao_seq'::regclass);
 I   ALTER TABLE public.devolucao ALTER COLUMN codigo_devolucao DROP DEFAULT;
       public          postgres    false    217    216            �           2604    49250    editora codigo_editora    DEFAULT     �   ALTER TABLE ONLY public.editora ALTER COLUMN codigo_editora SET DEFAULT nextval('public.editora_codigo_editora_seq'::regclass);
 E   ALTER TABLE public.editora ALTER COLUMN codigo_editora DROP DEFAULT;
       public          postgres    false    219    218            �           2604    49251    emprestimo codigo_emprestimo    DEFAULT     �   ALTER TABLE ONLY public.emprestimo ALTER COLUMN codigo_emprestimo SET DEFAULT nextval('public.emprestimo_codigo_emprestimo_seq'::regclass);
 K   ALTER TABLE public.emprestimo ALTER COLUMN codigo_emprestimo DROP DEFAULT;
       public          postgres    false    221    220            �           2604    49254    estante codigo_estante    DEFAULT     �   ALTER TABLE ONLY public.estante ALTER COLUMN codigo_estante SET DEFAULT nextval('public.estante_codigo_estante_seq'::regclass);
 E   ALTER TABLE public.estante ALTER COLUMN codigo_estante DROP DEFAULT;
       public          postgres    false    225    224            �           2604    49255    exemplar codigo_exemplar    DEFAULT     �   ALTER TABLE ONLY public.exemplar ALTER COLUMN codigo_exemplar SET DEFAULT nextval('public.exemplar_codigo_exemplar_seq'::regclass);
 G   ALTER TABLE public.exemplar ALTER COLUMN codigo_exemplar DROP DEFAULT;
       public          postgres    false    228    227            �           2604    49256    multa codigo_multa    DEFAULT     x   ALTER TABLE ONLY public.multa ALTER COLUMN codigo_multa SET DEFAULT nextval('public.multa_codigo_multa_seq'::regclass);
 A   ALTER TABLE public.multa ALTER COLUMN codigo_multa DROP DEFAULT;
       public          postgres    false    231    230            �           2604    49257    secao codigo_secao    DEFAULT     x   ALTER TABLE ONLY public.secao ALTER COLUMN codigo_secao SET DEFAULT nextval('public.secao_codigo_secao_seq'::regclass);
 A   ALTER TABLE public.secao ALTER COLUMN codigo_secao DROP DEFAULT;
       public          postgres    false    233    232            �           2604    49258    usuario codigo_usuario    DEFAULT     x   ALTER TABLE ONLY public.usuario ALTER COLUMN codigo_usuario SET DEFAULT nextval('public.usuario_codigo_seq'::regclass);
 E   ALTER TABLE public.usuario ALTER COLUMN codigo_usuario DROP DEFAULT;
       public          postgres    false    235    234            t          0    49158    autor 
   TABLE DATA           3   COPY public.autor (codigo_autor, nome) FROM stdin;
    public          postgres    false    209   i�       v          0    49164    bibliotecario 
   TABLE DATA           i   COPY public.bibliotecario (codigo_bibliotecario, nome, rg, cpf, nascimento, telefone, email) FROM stdin;
    public          postgres    false    211   ��       x          0    49170 	   categoria 
   TABLE DATA           ;   COPY public.categoria (codigo_categoria, nome) FROM stdin;
    public          postgres    false    213   r�       z          0    49176    categoria_subordinada 
   TABLE DATA           ]   COPY public.categoria_subordinada (codigo_super_categoria, codigo_sub_categoria) FROM stdin;
    public          postgres    false    215   ��       {          0    49179 	   devolucao 
   TABLE DATA           ~   COPY public.devolucao (codigo_devolucao, data_devolucao, hora_devolucao, codigo_emprestimo, codigo_bibliotecario) FROM stdin;
    public          postgres    false    216   ؚ       }          0    49185    editora 
   TABLE DATA           7   COPY public.editora (codigo_editora, nome) FROM stdin;
    public          postgres    false    218   1�                 0    49191 
   emprestimo 
   TABLE DATA           �   COPY public.emprestimo (codigo_emprestimo, data_emprestimo, hora_emprestimo, codigo_usuario, codigo_bibliotecario, codigo_exemplar, data_final) FROM stdin;
    public          postgres    false    220   n�       �          0    49198    endereco_bibliotecario 
   TABLE DATA           �   COPY public.endereco_bibliotecario (codigo_endereco_bibliotecario, codigo_bibliotecario, rotulo, logradouro, numero, complemento, bairro, cidade, estado, cep) FROM stdin;
    public          postgres    false    222   ܛ       �          0    49204    endereco_usuario 
   TABLE DATA           �   COPY public.endereco_usuario (codigo_endereco_usuario, codigo_usuario, rotulo, logradouro, numero, complemento, bairro, cidade, estado, cep) FROM stdin;
    public          postgres    false    223   �       �          0    49210    estante 
   TABLE DATA           :   COPY public.estante (codigo_estante, "Local") FROM stdin;
    public          postgres    false    224   e�       �          0    49216    estante_secao 
   TABLE DATA           E   COPY public.estante_secao (codigo_estante, codigo_secao) FROM stdin;
    public          postgres    false    226   ��       �          0    49219    exemplar 
   TABLE DATA           T   COPY public.exemplar (codigo_exemplar, data_aquisicao, descricao, isbn) FROM stdin;
    public          postgres    false    227   מ       �          0    49225    livro 
   TABLE DATA           �   COPY public.livro (isbn, palavras_chave, data_publicacao, titulo, codigo_editora, codigo_categoria, idioma, codigo_autor) FROM stdin;
    public          postgres    false    229   E�       �          0    49230    multa 
   TABLE DATA           �   COPY public.multa (codigo_multa, dias_atraso, valor, data_pagamento, hora_pagamento, codigo_emprestimo, codigo_bibliotecario) FROM stdin;
    public          postgres    false    230   ޟ       �          0    49234    secao 
   TABLE DATA           3   COPY public.secao (codigo_secao, nome) FROM stdin;
    public          postgres    false    232   +�       �          0    49240    usuario 
   TABLE DATA           ]   COPY public.usuario (codigo_usuario, nome, nascimento, rg, cpf, telefone, email) FROM stdin;
    public          postgres    false    234   h�       �           0    0    autor_codigo_autor_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.autor_codigo_autor_seq', 1, false);
          public          postgres    false    210            �           0    0    bibliotecario_codigo_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.bibliotecario_codigo_seq', 1, false);
          public          postgres    false    212            �           0    0    categoria_codigo_categoria_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.categoria_codigo_categoria_seq', 1, false);
          public          postgres    false    214            �           0    0    devolucao_codigo_devolucao_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.devolucao_codigo_devolucao_seq', 6, true);
          public          postgres    false    217            �           0    0    editora_codigo_editora_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.editora_codigo_editora_seq', 1, false);
          public          postgres    false    219            �           0    0     emprestimo_codigo_emprestimo_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('public.emprestimo_codigo_emprestimo_seq', 24, true);
          public          postgres    false    221            �           0    0    estante_codigo_estante_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.estante_codigo_estante_seq', 1, false);
          public          postgres    false    225            �           0    0    exemplar_codigo_exemplar_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.exemplar_codigo_exemplar_seq', 1, false);
          public          postgres    false    228            �           0    0    multa_codigo_multa_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.multa_codigo_multa_seq', 1, false);
          public          postgres    false    231            �           0    0    secao_codigo_secao_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.secao_codigo_secao_seq', 1, false);
          public          postgres    false    233            �           0    0    usuario_codigo_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.usuario_codigo_seq', 6, true);
          public          postgres    false    235            �           2606    49260    autor autor_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.autor
    ADD CONSTRAINT autor_pkey PRIMARY KEY (codigo_autor);
 :   ALTER TABLE ONLY public.autor DROP CONSTRAINT autor_pkey;
       public            postgres    false    209            �           2606    49262     bibliotecario bibliotecario_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.bibliotecario
    ADD CONSTRAINT bibliotecario_pkey PRIMARY KEY (codigo_bibliotecario);
 J   ALTER TABLE ONLY public.bibliotecario DROP CONSTRAINT bibliotecario_pkey;
       public            postgres    false    211            �           2606    49264    categoria categoria_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.categoria
    ADD CONSTRAINT categoria_pkey PRIMARY KEY (codigo_categoria);
 B   ALTER TABLE ONLY public.categoria DROP CONSTRAINT categoria_pkey;
       public            postgres    false    213            �           2606    49266 0   categoria_subordinada categoria_subordinada_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.categoria_subordinada
    ADD CONSTRAINT categoria_subordinada_pkey PRIMARY KEY (codigo_super_categoria, codigo_sub_categoria);
 Z   ALTER TABLE ONLY public.categoria_subordinada DROP CONSTRAINT categoria_subordinada_pkey;
       public            postgres    false    215    215            �           2606    49557    devolucao devolucao_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.devolucao
    ADD CONSTRAINT devolucao_pkey PRIMARY KEY (codigo_devolucao);
 B   ALTER TABLE ONLY public.devolucao DROP CONSTRAINT devolucao_pkey;
       public            postgres    false    216            �           2606    49268    editora editora_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.editora
    ADD CONSTRAINT editora_pkey PRIMARY KEY (codigo_editora);
 >   ALTER TABLE ONLY public.editora DROP CONSTRAINT editora_pkey;
       public            postgres    false    218            �           2606    49270    emprestimo emprestimo_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY public.emprestimo
    ADD CONSTRAINT emprestimo_pkey PRIMARY KEY (codigo_emprestimo);
 D   ALTER TABLE ONLY public.emprestimo DROP CONSTRAINT emprestimo_pkey;
       public            postgres    false    220            �           2606    49272 2   endereco_bibliotecario endereco_bibliotecario_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.endereco_bibliotecario
    ADD CONSTRAINT endereco_bibliotecario_pkey PRIMARY KEY (codigo_endereco_bibliotecario, codigo_bibliotecario);
 \   ALTER TABLE ONLY public.endereco_bibliotecario DROP CONSTRAINT endereco_bibliotecario_pkey;
       public            postgres    false    222    222            �           2606    49274 &   endereco_usuario endereco_usuario_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.endereco_usuario
    ADD CONSTRAINT endereco_usuario_pkey PRIMARY KEY (codigo_endereco_usuario, codigo_usuario);
 P   ALTER TABLE ONLY public.endereco_usuario DROP CONSTRAINT endereco_usuario_pkey;
       public            postgres    false    223    223            �           2606    49276    estante estante_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.estante
    ADD CONSTRAINT estante_pkey PRIMARY KEY (codigo_estante);
 >   ALTER TABLE ONLY public.estante DROP CONSTRAINT estante_pkey;
       public            postgres    false    224            �           2606    49278     estante_secao estante_secao_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public.estante_secao
    ADD CONSTRAINT estante_secao_pkey PRIMARY KEY (codigo_estante, codigo_secao);
 J   ALTER TABLE ONLY public.estante_secao DROP CONSTRAINT estante_secao_pkey;
       public            postgres    false    226    226            �           2606    49280    exemplar exemplar_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.exemplar
    ADD CONSTRAINT exemplar_pkey PRIMARY KEY (codigo_exemplar);
 @   ALTER TABLE ONLY public.exemplar DROP CONSTRAINT exemplar_pkey;
       public            postgres    false    227            �           2606    49282    livro livro_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.livro
    ADD CONSTRAINT livro_pkey PRIMARY KEY (isbn);
 :   ALTER TABLE ONLY public.livro DROP CONSTRAINT livro_pkey;
       public            postgres    false    229            �           2606    49284    multa multa_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.multa
    ADD CONSTRAINT multa_pkey PRIMARY KEY (codigo_multa);
 :   ALTER TABLE ONLY public.multa DROP CONSTRAINT multa_pkey;
       public            postgres    false    230            �           2606    49286    secao secao_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.secao
    ADD CONSTRAINT secao_pkey PRIMARY KEY (codigo_secao);
 :   ALTER TABLE ONLY public.secao DROP CONSTRAINT secao_pkey;
       public            postgres    false    232            �           2606    49288    usuario usuario_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (codigo_usuario);
 >   ALTER TABLE ONLY public.usuario DROP CONSTRAINT usuario_pkey;
       public            postgres    false    234            �           2620    49289 &   emprestimo tg_checkemprestimopendencia    TRIGGER     �   CREATE TRIGGER tg_checkemprestimopendencia AFTER INSERT ON public.emprestimo FOR EACH STATEMENT EXECUTE FUNCTION public.checkemprestimopendencia();
 ?   DROP TRIGGER tg_checkemprestimopendencia ON public.emprestimo;
       public          postgres    false    250    220            �           2620    49290 '   categoria tg_deletecategoriasubordinada    TRIGGER     �   CREATE TRIGGER tg_deletecategoriasubordinada BEFORE DELETE ON public.categoria FOR EACH ROW EXECUTE FUNCTION public.deletecategoriasubordinada();
 @   DROP TRIGGER tg_deletecategoriasubordinada ON public.categoria;
       public          postgres    false    249    213            �           2620    49291    livro tg_deletelivroexemplar    TRIGGER     �   CREATE TRIGGER tg_deletelivroexemplar BEFORE DELETE ON public.livro FOR EACH ROW EXECUTE FUNCTION public.deletelivroexemplar();
 5   DROP TRIGGER tg_deletelivroexemplar ON public.livro;
       public          postgres    false    247    229            �           2620    49292    exemplar tg_setnullexemplar    TRIGGER     �   CREATE TRIGGER tg_setnullexemplar BEFORE DELETE ON public.exemplar FOR EACH ROW EXECUTE FUNCTION public.setnullemprestimoexemplar();
 4   DROP TRIGGER tg_setnullexemplar ON public.exemplar;
       public          postgres    false    227    248            �           2606    49558    livro autor_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.livro
    ADD CONSTRAINT autor_fkey FOREIGN KEY (codigo_autor) REFERENCES public.autor(codigo_autor) NOT VALID;
 :   ALTER TABLE ONLY public.livro DROP CONSTRAINT autor_fkey;
       public          postgres    false    209    229    3255            �           2606    49293    emprestimo bibliotecario_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.emprestimo
    ADD CONSTRAINT bibliotecario_fkey FOREIGN KEY (codigo_bibliotecario) REFERENCES public.bibliotecario(codigo_bibliotecario) NOT VALID;
 G   ALTER TABLE ONLY public.emprestimo DROP CONSTRAINT bibliotecario_fkey;
       public          postgres    false    220    211    3257            �           2606    49298 )   endereco_bibliotecario bibliotecario_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.endereco_bibliotecario
    ADD CONSTRAINT bibliotecario_fkey FOREIGN KEY (codigo_bibliotecario) REFERENCES public.bibliotecario(codigo_bibliotecario) NOT VALID;
 S   ALTER TABLE ONLY public.endereco_bibliotecario DROP CONSTRAINT bibliotecario_fkey;
       public          postgres    false    3257    222    211            �           2606    49303    livro categoria_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.livro
    ADD CONSTRAINT categoria_fkey FOREIGN KEY (codigo_categoria) REFERENCES public.categoria(codigo_categoria) NOT VALID;
 >   ALTER TABLE ONLY public.livro DROP CONSTRAINT categoria_fkey;
       public          postgres    false    213    229    3259            �           2606    49308    livro editora_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.livro
    ADD CONSTRAINT editora_fkey FOREIGN KEY (codigo_editora) REFERENCES public.editora(codigo_editora) NOT VALID;
 <   ALTER TABLE ONLY public.livro DROP CONSTRAINT editora_fkey;
       public          postgres    false    218    3265    229            �           2606    49313    multa emprestimo_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.multa
    ADD CONSTRAINT emprestimo_fkey FOREIGN KEY (codigo_emprestimo) REFERENCES public.emprestimo(codigo_emprestimo) NOT VALID;
 ?   ALTER TABLE ONLY public.multa DROP CONSTRAINT emprestimo_fkey;
       public          postgres    false    3267    230    220            �           2606    49318    devolucao emprestimo_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.devolucao
    ADD CONSTRAINT emprestimo_fkey FOREIGN KEY (codigo_emprestimo) REFERENCES public.emprestimo(codigo_emprestimo) NOT VALID;
 C   ALTER TABLE ONLY public.devolucao DROP CONSTRAINT emprestimo_fkey;
       public          postgres    false    3267    216    220            �           2606    49323    estante_secao estante_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.estante_secao
    ADD CONSTRAINT estante_fkey FOREIGN KEY (codigo_estante) REFERENCES public.estante(codigo_estante) NOT VALID;
 D   ALTER TABLE ONLY public.estante_secao DROP CONSTRAINT estante_fkey;
       public          postgres    false    224    3273    226            �           2606    49328    emprestimo exemplar_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.emprestimo
    ADD CONSTRAINT exemplar_fkey FOREIGN KEY (codigo_exemplar) REFERENCES public.exemplar(codigo_exemplar) NOT VALID;
 B   ALTER TABLE ONLY public.emprestimo DROP CONSTRAINT exemplar_fkey;
       public          postgres    false    3277    227    220            �           2606    49333    exemplar livro_fkey    FK CONSTRAINT     {   ALTER TABLE ONLY public.exemplar
    ADD CONSTRAINT livro_fkey FOREIGN KEY (isbn) REFERENCES public.livro(isbn) NOT VALID;
 =   ALTER TABLE ONLY public.exemplar DROP CONSTRAINT livro_fkey;
       public          postgres    false    227    3279    229            �           2606    49338    estante_secao secao_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.estante_secao
    ADD CONSTRAINT secao_fkey FOREIGN KEY (codigo_secao) REFERENCES public.secao(codigo_secao) NOT VALID;
 B   ALTER TABLE ONLY public.estante_secao DROP CONSTRAINT secao_fkey;
       public          postgres    false    226    232    3283            �           2606    49343 (   categoria_subordinada sub_categoria_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.categoria_subordinada
    ADD CONSTRAINT sub_categoria_fkey FOREIGN KEY (codigo_sub_categoria) REFERENCES public.categoria(codigo_categoria) NOT VALID;
 R   ALTER TABLE ONLY public.categoria_subordinada DROP CONSTRAINT sub_categoria_fkey;
       public          postgres    false    3259    213    215            �           2606    49348 *   categoria_subordinada super_categoria_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.categoria_subordinada
    ADD CONSTRAINT super_categoria_fkey FOREIGN KEY (codigo_super_categoria) REFERENCES public.categoria(codigo_categoria) NOT VALID;
 T   ALTER TABLE ONLY public.categoria_subordinada DROP CONSTRAINT super_categoria_fkey;
       public          postgres    false    213    3259    215            �           2606    49353    emprestimo usuario_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.emprestimo
    ADD CONSTRAINT usuario_fkey FOREIGN KEY (codigo_usuario) REFERENCES public.usuario(codigo_usuario) NOT VALID;
 A   ALTER TABLE ONLY public.emprestimo DROP CONSTRAINT usuario_fkey;
       public          postgres    false    220    234    3285            �           2606    49358    endereco_usuario usuario_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.endereco_usuario
    ADD CONSTRAINT usuario_fkey FOREIGN KEY (codigo_usuario) REFERENCES public.usuario(codigo_usuario) NOT VALID;
 G   ALTER TABLE ONLY public.endereco_usuario DROP CONSTRAINT usuario_fkey;
       public          postgres    false    234    223    3285            t   +   x�3�t,-�/R00�2�1�LaLS.ӄ��4����� �U�      v   �   x�m�K
�@�uz
`��p'�Í�B� �Ļ�dZCC���Gp��8��=·���P���=a4|�N��q�y���Ǟ���m��0�:n5��u�CJ�cth�}�x�V�I�	���R��C[��i��i�4m5բu�CJ�bth�U7��=M�f�f`V�zH�\3�m�ڦ���YҮ��?D      x   /   x�3�tN,IM�/�LT00�2A�p#s�����F\��\C�=... ��a      z      x�3�4�2�4b#�=... �      {   I   x�E��	 1Dѳ��řh�Z��_G,���Ch�0@`i7����-,�-�2K��mq	]��aK;Y�Kߣ��L      }   -   x�3�tM�,�/JT00�2ApL��c.#ǈ��1����� �t~         ^   x�U�[� D�of/�NY��_��������IYTT��B�N�lmHh2M�_�)<�'��f�H�b�Y��Y2�mf�u�Wi�1������: ܣ/'}      �      x�}�=j�0�z|
_ ���ʍI ]0)�(k^+h�)r�=�^,����)f$���(Px�z���Ο��O����ͮnh�>|�xq'?]����׭u���#�v@)��>4MSQ`{$�I^H�H�	�<�|�� 1))��Ï�[H)��2�b�Ԡ1���-���5�ZgP�,m-<�������n�y��%��f��6�|�cY
�����a�e�m�"�@Q@���!2ȷA
���
�J�T�6h�`���Uc1�dNnr��4�^:�����І$su�IUU�-
�e      �   I  x�}�Mj�0����@�G�Z����J�%��Dŉ��r�\�rj��/�|��<O�.��z��6��.��`;���t�����������������^����i�
���%E!!�`B�L�5R���*��6��0�~&�bJ�L�5Ҁ��)���8�.Π1��A�:ptt���.�/��^�v�9�n0'���_���	��I��3�y�2(S.��$K)��2�bԠ)��	�5�ZgP.�,m�]5�2km��"����K��K��f�a�̮�s��M)�j�T��v�s��]y��"L�H��>���X�wVU�5k*�      �   &   x�3�N�IT00�2����,#.8��2����� cW      �   ,   x�3�4�2�4�2�4bC.cNS 6�2��`l����� }�`      �   ^   x�3�4200�50"N׊�܂��"����T��!�^y#.c���\&x�M���F��F@����q��5ߔ��~.���\�x�r��qqq ��P�      �   �   x�U�=
A��:9�pd�7�[����J���n���W<���M���_��{�Ժ�z�?���w��Z���

<�����V��6/�Ԇ�BSՔ����lmـ�Csh��S�[��q��G�#��k_O����?_      �   =   x�3�4�RQ0�10�4202�50�54�44�2 !NcNC.#NS�S5�5&�F\1z\\\ �d      �   -   x�3�N=����|S.Ǆ��1�2Bp��C�=... ��i      �   �   x�U�1N1��s
�D�c[��t4+*(�T��p.���(��/���!<]�����~W�ֺW��={���7��wv����z\쯊���z�����B�J�<�P\��O'B�-���Ҡ��<�����&2zFZB8 ���C8.G��DF�'D")�1D�rĪLd�HBt ����PP-���Ko�U�����d<�m��.Ҙ�     