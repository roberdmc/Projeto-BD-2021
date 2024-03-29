toc.dat                                                                                             0000600 0004000 0002000 00000103510 14274043535 0014446 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        PGDMP       $                    z            Projeto-BD-Biblioteca    14.4    14.4 k    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false         �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false         �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false         �           1262    49152    Projeto-BD-Biblioteca    DATABASE     w   CREATE DATABASE "Projeto-BD-Biblioteca" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Portuguese_Brazil.1252';
 '   DROP DATABASE "Projeto-BD-Biblioteca";
                postgres    false         �            1255    49154    checkemprestimopendencia()    FUNCTION     T  CREATE FUNCTION public.checkemprestimopendencia() RETURNS trigger
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
       public          postgres    false         �            1255    49155    deletecategoriasubordinada()    FUNCTION       CREATE FUNCTION public.deletecategoriasubordinada() RETURNS trigger
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
       public          postgres    false         �            1255    49156    deletelivroexemplar()    FUNCTION       CREATE FUNCTION public.deletelivroexemplar() RETURNS trigger
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
       public          postgres    false         �            1255    49157    setnullemprestimoexemplar()    FUNCTION     C  CREATE FUNCTION public.setnullemprestimoexemplar() RETURNS trigger
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
       public          postgres    false         �            1259    49158    autor    TABLE     �   CREATE TABLE public.autor (
    codigo_autor integer NOT NULL,
    nome character varying(255)
)
WITH (autovacuum_enabled='true');
    DROP TABLE public.autor;
       public         heap    postgres    false         �            1259    49163    autor_codigo_autor_seq    SEQUENCE     �   CREATE SEQUENCE public.autor_codigo_autor_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.autor_codigo_autor_seq;
       public          postgres    false    209         �           0    0    autor_codigo_autor_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.autor_codigo_autor_seq OWNED BY public.autor.codigo_autor;
          public          postgres    false    210         �            1259    49169    bibliotecario_codigo_seq    SEQUENCE     �   CREATE SEQUENCE public.bibliotecario_codigo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.bibliotecario_codigo_seq;
       public          postgres    false         �            1259    49164    bibliotecario    TABLE     T  CREATE TABLE public.bibliotecario (
    codigo_bibliotecario integer DEFAULT nextval('public.bibliotecario_codigo_seq'::regclass) NOT NULL,
    nome character varying(255),
    rg character(12),
    cpf character(14),
    nascimento date,
    email character varying(100),
    telefone character varying
)
WITH (autovacuum_enabled='true');
 !   DROP TABLE public.bibliotecario;
       public         heap    postgres    false    212         �            1259    49175    categoria_codigo_categoria_seq    SEQUENCE     �   CREATE SEQUENCE public.categoria_codigo_categoria_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public.categoria_codigo_categoria_seq;
       public          postgres    false         �            1259    49170 	   categoria    TABLE     �   CREATE TABLE public.categoria (
    codigo_categoria integer DEFAULT nextval('public.categoria_codigo_categoria_seq'::regclass) NOT NULL,
    nome character varying(255)
)
WITH (autovacuum_enabled='true');
    DROP TABLE public.categoria;
       public         heap    postgres    false    214         �            1259    49176    categoria_subordinada    TABLE     �   CREATE TABLE public.categoria_subordinada (
    codigo_super_categoria integer NOT NULL,
    codigo_sub_categoria integer NOT NULL
)
WITH (autovacuum_enabled='true');
 )   DROP TABLE public.categoria_subordinada;
       public         heap    postgres    false         �            1259    49179 	   devolucao    TABLE     !  CREATE TABLE public.devolucao (
    codigo_devolucao integer NOT NULL,
    data_devolucao date DEFAULT CURRENT_DATE,
    hora_devolucao time without time zone DEFAULT CURRENT_TIMESTAMP(0),
    codigo_emprestimo integer,
    codigo_bibliotecario integer
)
WITH (autovacuum_enabled='true');
    DROP TABLE public.devolucao;
       public         heap    postgres    false         �            1259    49184    devolucao_codigo_devolucao_seq    SEQUENCE     �   CREATE SEQUENCE public.devolucao_codigo_devolucao_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public.devolucao_codigo_devolucao_seq;
       public          postgres    false    216         �           0    0    devolucao_codigo_devolucao_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public.devolucao_codigo_devolucao_seq OWNED BY public.devolucao.codigo_devolucao;
          public          postgres    false    217         �            1259    49190    editora_codigo_editora_seq    SEQUENCE     �   CREATE SEQUENCE public.editora_codigo_editora_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.editora_codigo_editora_seq;
       public          postgres    false         �            1259    49185    editora    TABLE     �   CREATE TABLE public.editora (
    codigo_editora integer DEFAULT nextval('public.editora_codigo_editora_seq'::regclass) NOT NULL,
    nome character varying(255)
)
WITH (autovacuum_enabled='true');
    DROP TABLE public.editora;
       public         heap    postgres    false    219         �            1259    49197     emprestimo_codigo_emprestimo_seq    SEQUENCE     �   CREATE SEQUENCE public.emprestimo_codigo_emprestimo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 7   DROP SEQUENCE public.emprestimo_codigo_emprestimo_seq;
       public          postgres    false         �            1259    49191 
   emprestimo    TABLE     �  CREATE TABLE public.emprestimo (
    codigo_emprestimo integer DEFAULT nextval('public.emprestimo_codigo_emprestimo_seq'::regclass) NOT NULL,
    data_emprestimo date DEFAULT CURRENT_DATE,
    hora_emprestimo time without time zone DEFAULT CURRENT_TIMESTAMP(0),
    codigo_usuario integer,
    codigo_bibliotecario integer,
    codigo_exemplar integer,
    data_final date DEFAULT (CURRENT_DATE + 10)
)
WITH (autovacuum_enabled='true');
    DROP TABLE public.emprestimo;
       public         heap    postgres    false    221         �            1259    49198    endereco_bibliotecario    TABLE     �  CREATE TABLE public.endereco_bibliotecario (
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
)
WITH (autovacuum_enabled='true');
 *   DROP TABLE public.endereco_bibliotecario;
       public         heap    postgres    false         �            1259    49204    endereco_usuario    TABLE     �  CREATE TABLE public.endereco_usuario (
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
)
WITH (autovacuum_enabled='true');
 $   DROP TABLE public.endereco_usuario;
       public         heap    postgres    false         �            1259    49215    estante_codigo_estante_seq    SEQUENCE     �   CREATE SEQUENCE public.estante_codigo_estante_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.estante_codigo_estante_seq;
       public          postgres    false         �            1259    49210    estante    TABLE     �   CREATE TABLE public.estante (
    codigo_estante integer DEFAULT nextval('public.estante_codigo_estante_seq'::regclass) NOT NULL,
    "Local" character varying(255)
)
WITH (autovacuum_enabled='true');
    DROP TABLE public.estante;
       public         heap    postgres    false    225         �            1259    49216    estante_secao    TABLE     �   CREATE TABLE public.estante_secao (
    codigo_estante integer NOT NULL,
    codigo_secao integer NOT NULL
)
WITH (autovacuum_enabled='true');
 !   DROP TABLE public.estante_secao;
       public         heap    postgres    false         �            1259    49224    exemplar_codigo_exemplar_seq    SEQUENCE     �   CREATE SEQUENCE public.exemplar_codigo_exemplar_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.exemplar_codigo_exemplar_seq;
       public          postgres    false         �            1259    49219    exemplar    TABLE       CREATE TABLE public.exemplar (
    codigo_exemplar integer DEFAULT nextval('public.exemplar_codigo_exemplar_seq'::regclass) NOT NULL,
    data_aquisicao date,
    descricao character varying(255),
    isbn bigint,
    codigo_estante integer
)
WITH (autovacuum_enabled='true');
    DROP TABLE public.exemplar;
       public         heap    postgres    false    228         �            1259    49225    livro    TABLE       CREATE TABLE public.livro (
    isbn bigint NOT NULL,
    data_publicacao date,
    titulo character varying(255),
    codigo_editora integer,
    codigo_categoria integer,
    idioma character varying(5),
    codigo_autor integer
)
WITH (autovacuum_enabled='true');
    DROP TABLE public.livro;
       public         heap    postgres    false         �            1259    49230    multa    TABLE     C  CREATE TABLE public.multa (
    codigo_multa integer NOT NULL,
    dias_atraso integer,
    valor money,
    data_pagamento date DEFAULT CURRENT_DATE,
    hora_pagamento time without time zone DEFAULT CURRENT_TIMESTAMP(0),
    codigo_emprestimo integer,
    codigo_bibliotecario integer
)
WITH (autovacuum_enabled='true');
    DROP TABLE public.multa;
       public         heap    postgres    false         �            1259    49233    multa_codigo_multa_seq    SEQUENCE     �   CREATE SEQUENCE public.multa_codigo_multa_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.multa_codigo_multa_seq;
       public          postgres    false    230         �           0    0    multa_codigo_multa_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.multa_codigo_multa_seq OWNED BY public.multa.codigo_multa;
          public          postgres    false    231         �            1259    49239    secao_codigo_secao_seq    SEQUENCE     �   CREATE SEQUENCE public.secao_codigo_secao_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.secao_codigo_secao_seq;
       public          postgres    false         �            1259    49234    secao    TABLE     �   CREATE TABLE public.secao (
    codigo_secao integer DEFAULT nextval('public.secao_codigo_secao_seq'::regclass) NOT NULL,
    nome character varying(255)
)
WITH (autovacuum_enabled='true');
    DROP TABLE public.secao;
       public         heap    postgres    false    233         �            1259    49245    usuario_codigo_seq    SEQUENCE     �   CREATE SEQUENCE public.usuario_codigo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.usuario_codigo_seq;
       public          postgres    false         �            1259    49240    usuario    TABLE     R  CREATE TABLE public.usuario (
    codigo_usuario integer DEFAULT nextval('public.usuario_codigo_seq'::regclass) NOT NULL,
    nome character varying(255),
    nascimento date,
    rg character varying(12),
    cpf character varying(14),
    email character varying(100),
    telefone character varying
)
WITH (autovacuum_enabled='true');
    DROP TABLE public.usuario;
       public         heap    postgres    false    235         �           2604    49246    autor codigo_autor    DEFAULT     x   ALTER TABLE ONLY public.autor ALTER COLUMN codigo_autor SET DEFAULT nextval('public.autor_codigo_autor_seq'::regclass);
 A   ALTER TABLE public.autor ALTER COLUMN codigo_autor DROP DEFAULT;
       public          postgres    false    210    209         �           2604    49249    devolucao codigo_devolucao    DEFAULT     �   ALTER TABLE ONLY public.devolucao ALTER COLUMN codigo_devolucao SET DEFAULT nextval('public.devolucao_codigo_devolucao_seq'::regclass);
 I   ALTER TABLE public.devolucao ALTER COLUMN codigo_devolucao DROP DEFAULT;
       public          postgres    false    217    216         �           2604    49256    multa codigo_multa    DEFAULT     x   ALTER TABLE ONLY public.multa ALTER COLUMN codigo_multa SET DEFAULT nextval('public.multa_codigo_multa_seq'::regclass);
 A   ALTER TABLE public.multa ALTER COLUMN codigo_multa DROP DEFAULT;
       public          postgres    false    231    230         z          0    49158    autor 
   TABLE DATA                 public          postgres    false    209       3450.dat |          0    49164    bibliotecario 
   TABLE DATA                 public          postgres    false    211       3452.dat ~          0    49170 	   categoria 
   TABLE DATA                 public          postgres    false    213       3454.dat �          0    49176    categoria_subordinada 
   TABLE DATA                 public          postgres    false    215       3456.dat �          0    49179 	   devolucao 
   TABLE DATA                 public          postgres    false    216       3457.dat �          0    49185    editora 
   TABLE DATA                 public          postgres    false    218       3459.dat �          0    49191 
   emprestimo 
   TABLE DATA                 public          postgres    false    220       3461.dat �          0    49198    endereco_bibliotecario 
   TABLE DATA                 public          postgres    false    222       3463.dat �          0    49204    endereco_usuario 
   TABLE DATA                 public          postgres    false    223       3464.dat �          0    49210    estante 
   TABLE DATA                 public          postgres    false    224       3465.dat �          0    49216    estante_secao 
   TABLE DATA                 public          postgres    false    226       3467.dat �          0    49219    exemplar 
   TABLE DATA                 public          postgres    false    227       3468.dat �          0    49225    livro 
   TABLE DATA                 public          postgres    false    229       3470.dat �          0    49230    multa 
   TABLE DATA                 public          postgres    false    230       3471.dat �          0    49234    secao 
   TABLE DATA                 public          postgres    false    232       3473.dat �          0    49240    usuario 
   TABLE DATA                 public          postgres    false    234       3475.dat �           0    0    autor_codigo_autor_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.autor_codigo_autor_seq', 6, true);
          public          postgres    false    210         �           0    0    bibliotecario_codigo_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.bibliotecario_codigo_seq', 6, true);
          public          postgres    false    212         �           0    0    categoria_codigo_categoria_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.categoria_codigo_categoria_seq', 6, true);
          public          postgres    false    214         �           0    0    devolucao_codigo_devolucao_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.devolucao_codigo_devolucao_seq', 6, true);
          public          postgres    false    217         �           0    0    editora_codigo_editora_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.editora_codigo_editora_seq', 6, true);
          public          postgres    false    219         �           0    0     emprestimo_codigo_emprestimo_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('public.emprestimo_codigo_emprestimo_seq', 25, true);
          public          postgres    false    221         �           0    0    estante_codigo_estante_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.estante_codigo_estante_seq', 6, true);
          public          postgres    false    225         �           0    0    exemplar_codigo_exemplar_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.exemplar_codigo_exemplar_seq', 11, true);
          public          postgres    false    228         �           0    0    multa_codigo_multa_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.multa_codigo_multa_seq', 5, true);
          public          postgres    false    231         �           0    0    secao_codigo_secao_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.secao_codigo_secao_seq', 6, true);
          public          postgres    false    233         �           0    0    usuario_codigo_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.usuario_codigo_seq', 7, true);
          public          postgres    false    235         �           2606    49260    autor autor_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.autor
    ADD CONSTRAINT autor_pkey PRIMARY KEY (codigo_autor);
 :   ALTER TABLE ONLY public.autor DROP CONSTRAINT autor_pkey;
       public            postgres    false    209         �           2606    49262     bibliotecario bibliotecario_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.bibliotecario
    ADD CONSTRAINT bibliotecario_pkey PRIMARY KEY (codigo_bibliotecario);
 J   ALTER TABLE ONLY public.bibliotecario DROP CONSTRAINT bibliotecario_pkey;
       public            postgres    false    211         �           2606    49264    categoria categoria_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.categoria
    ADD CONSTRAINT categoria_pkey PRIMARY KEY (codigo_categoria);
 B   ALTER TABLE ONLY public.categoria DROP CONSTRAINT categoria_pkey;
       public            postgres    false    213         �           2606    49266 0   categoria_subordinada categoria_subordinada_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.categoria_subordinada
    ADD CONSTRAINT categoria_subordinada_pkey PRIMARY KEY (codigo_super_categoria, codigo_sub_categoria);
 Z   ALTER TABLE ONLY public.categoria_subordinada DROP CONSTRAINT categoria_subordinada_pkey;
       public            postgres    false    215    215         �           2606    49557    devolucao devolucao_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.devolucao
    ADD CONSTRAINT devolucao_pkey PRIMARY KEY (codigo_devolucao);
 B   ALTER TABLE ONLY public.devolucao DROP CONSTRAINT devolucao_pkey;
       public            postgres    false    216         �           2606    49268    editora editora_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.editora
    ADD CONSTRAINT editora_pkey PRIMARY KEY (codigo_editora);
 >   ALTER TABLE ONLY public.editora DROP CONSTRAINT editora_pkey;
       public            postgres    false    218         �           2606    49270    emprestimo emprestimo_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY public.emprestimo
    ADD CONSTRAINT emprestimo_pkey PRIMARY KEY (codigo_emprestimo);
 D   ALTER TABLE ONLY public.emprestimo DROP CONSTRAINT emprestimo_pkey;
       public            postgres    false    220         �           2606    49272 2   endereco_bibliotecario endereco_bibliotecario_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.endereco_bibliotecario
    ADD CONSTRAINT endereco_bibliotecario_pkey PRIMARY KEY (codigo_endereco_bibliotecario, codigo_bibliotecario);
 \   ALTER TABLE ONLY public.endereco_bibliotecario DROP CONSTRAINT endereco_bibliotecario_pkey;
       public            postgres    false    222    222         �           2606    49274 &   endereco_usuario endereco_usuario_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.endereco_usuario
    ADD CONSTRAINT endereco_usuario_pkey PRIMARY KEY (codigo_endereco_usuario, codigo_usuario);
 P   ALTER TABLE ONLY public.endereco_usuario DROP CONSTRAINT endereco_usuario_pkey;
       public            postgres    false    223    223         �           2606    49276    estante estante_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.estante
    ADD CONSTRAINT estante_pkey PRIMARY KEY (codigo_estante);
 >   ALTER TABLE ONLY public.estante DROP CONSTRAINT estante_pkey;
       public            postgres    false    224         �           2606    49278     estante_secao estante_secao_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public.estante_secao
    ADD CONSTRAINT estante_secao_pkey PRIMARY KEY (codigo_estante, codigo_secao);
 J   ALTER TABLE ONLY public.estante_secao DROP CONSTRAINT estante_secao_pkey;
       public            postgres    false    226    226         �           2606    49280    exemplar exemplar_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.exemplar
    ADD CONSTRAINT exemplar_pkey PRIMARY KEY (codigo_exemplar);
 @   ALTER TABLE ONLY public.exemplar DROP CONSTRAINT exemplar_pkey;
       public            postgres    false    227         �           2606    49282    livro livro_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.livro
    ADD CONSTRAINT livro_pkey PRIMARY KEY (isbn);
 :   ALTER TABLE ONLY public.livro DROP CONSTRAINT livro_pkey;
       public            postgres    false    229         �           2606    49284    multa multa_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.multa
    ADD CONSTRAINT multa_pkey PRIMARY KEY (codigo_multa);
 :   ALTER TABLE ONLY public.multa DROP CONSTRAINT multa_pkey;
       public            postgres    false    230         �           2606    49286    secao secao_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.secao
    ADD CONSTRAINT secao_pkey PRIMARY KEY (codigo_secao);
 :   ALTER TABLE ONLY public.secao DROP CONSTRAINT secao_pkey;
       public            postgres    false    232         �           2606    49288    usuario usuario_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (codigo_usuario);
 >   ALTER TABLE ONLY public.usuario DROP CONSTRAINT usuario_pkey;
       public            postgres    false    234         �           1259    49571    unq_cpf_bib    INDEX     K   CREATE UNIQUE INDEX unq_cpf_bib ON public.bibliotecario USING btree (cpf);
    DROP INDEX public.unq_cpf_bib;
       public            postgres    false    211         �           1259    49570    unq_cpf_usu    INDEX     E   CREATE UNIQUE INDEX unq_cpf_usu ON public.usuario USING btree (cpf);
    DROP INDEX public.unq_cpf_usu;
       public            postgres    false    234         �           1259    49572    unq_isbn    INDEX     A   CREATE UNIQUE INDEX unq_isbn ON public.livro USING btree (isbn);
    DROP INDEX public.unq_isbn;
       public            postgres    false    229         �           2620    49289 &   emprestimo tg_checkemprestimopendencia    TRIGGER     �   CREATE TRIGGER tg_checkemprestimopendencia AFTER INSERT ON public.emprestimo FOR EACH STATEMENT EXECUTE FUNCTION public.checkemprestimopendencia();
 ?   DROP TRIGGER tg_checkemprestimopendencia ON public.emprestimo;
       public          postgres    false    220    250         �           2620    49290 '   categoria tg_deletecategoriasubordinada    TRIGGER     �   CREATE TRIGGER tg_deletecategoriasubordinada BEFORE DELETE ON public.categoria FOR EACH ROW EXECUTE FUNCTION public.deletecategoriasubordinada();
 @   DROP TRIGGER tg_deletecategoriasubordinada ON public.categoria;
       public          postgres    false    213    249         �           2620    49291    livro tg_deletelivroexemplar    TRIGGER     �   CREATE TRIGGER tg_deletelivroexemplar BEFORE DELETE ON public.livro FOR EACH ROW EXECUTE FUNCTION public.deletelivroexemplar();
 5   DROP TRIGGER tg_deletelivroexemplar ON public.livro;
       public          postgres    false    229    247         �           2620    49292    exemplar tg_setnullexemplar    TRIGGER     �   CREATE TRIGGER tg_setnullexemplar BEFORE DELETE ON public.exemplar FOR EACH ROW EXECUTE FUNCTION public.setnullemprestimoexemplar();
 4   DROP TRIGGER tg_setnullexemplar ON public.exemplar;
       public          postgres    false    248    227         �           2606    49558    livro autor_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.livro
    ADD CONSTRAINT autor_fkey FOREIGN KEY (codigo_autor) REFERENCES public.autor(codigo_autor) NOT VALID;
 :   ALTER TABLE ONLY public.livro DROP CONSTRAINT autor_fkey;
       public          postgres    false    209    229    3257         �           2606    49293    emprestimo bibliotecario_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.emprestimo
    ADD CONSTRAINT bibliotecario_fkey FOREIGN KEY (codigo_bibliotecario) REFERENCES public.bibliotecario(codigo_bibliotecario) NOT VALID;
 G   ALTER TABLE ONLY public.emprestimo DROP CONSTRAINT bibliotecario_fkey;
       public          postgres    false    220    3259    211         �           2606    49298 )   endereco_bibliotecario bibliotecario_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.endereco_bibliotecario
    ADD CONSTRAINT bibliotecario_fkey FOREIGN KEY (codigo_bibliotecario) REFERENCES public.bibliotecario(codigo_bibliotecario) NOT VALID;
 S   ALTER TABLE ONLY public.endereco_bibliotecario DROP CONSTRAINT bibliotecario_fkey;
       public          postgres    false    222    211    3259         �           2606    49303    livro categoria_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.livro
    ADD CONSTRAINT categoria_fkey FOREIGN KEY (codigo_categoria) REFERENCES public.categoria(codigo_categoria) NOT VALID;
 >   ALTER TABLE ONLY public.livro DROP CONSTRAINT categoria_fkey;
       public          postgres    false    229    213    3262         �           2606    49308    livro editora_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.livro
    ADD CONSTRAINT editora_fkey FOREIGN KEY (codigo_editora) REFERENCES public.editora(codigo_editora) NOT VALID;
 <   ALTER TABLE ONLY public.livro DROP CONSTRAINT editora_fkey;
       public          postgres    false    3268    218    229         �           2606    49313    multa emprestimo_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.multa
    ADD CONSTRAINT emprestimo_fkey FOREIGN KEY (codigo_emprestimo) REFERENCES public.emprestimo(codigo_emprestimo) NOT VALID;
 ?   ALTER TABLE ONLY public.multa DROP CONSTRAINT emprestimo_fkey;
       public          postgres    false    220    230    3270         �           2606    49318    devolucao emprestimo_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.devolucao
    ADD CONSTRAINT emprestimo_fkey FOREIGN KEY (codigo_emprestimo) REFERENCES public.emprestimo(codigo_emprestimo) NOT VALID;
 C   ALTER TABLE ONLY public.devolucao DROP CONSTRAINT emprestimo_fkey;
       public          postgres    false    216    220    3270         �           2606    49323    estante_secao estante_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.estante_secao
    ADD CONSTRAINT estante_fkey FOREIGN KEY (codigo_estante) REFERENCES public.estante(codigo_estante) NOT VALID;
 D   ALTER TABLE ONLY public.estante_secao DROP CONSTRAINT estante_fkey;
       public          postgres    false    224    3276    226         �           2606    49565    exemplar estante_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.exemplar
    ADD CONSTRAINT estante_fkey FOREIGN KEY (codigo_estante) REFERENCES public.estante(codigo_estante) NOT VALID;
 ?   ALTER TABLE ONLY public.exemplar DROP CONSTRAINT estante_fkey;
       public          postgres    false    3276    224    227         �           2606    49328    emprestimo exemplar_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.emprestimo
    ADD CONSTRAINT exemplar_fkey FOREIGN KEY (codigo_exemplar) REFERENCES public.exemplar(codigo_exemplar) NOT VALID;
 B   ALTER TABLE ONLY public.emprestimo DROP CONSTRAINT exemplar_fkey;
       public          postgres    false    220    3280    227         �           2606    49333    exemplar livro_fkey    FK CONSTRAINT     {   ALTER TABLE ONLY public.exemplar
    ADD CONSTRAINT livro_fkey FOREIGN KEY (isbn) REFERENCES public.livro(isbn) NOT VALID;
 =   ALTER TABLE ONLY public.exemplar DROP CONSTRAINT livro_fkey;
       public          postgres    false    229    227    3282         �           2606    49338    estante_secao secao_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.estante_secao
    ADD CONSTRAINT secao_fkey FOREIGN KEY (codigo_secao) REFERENCES public.secao(codigo_secao) NOT VALID;
 B   ALTER TABLE ONLY public.estante_secao DROP CONSTRAINT secao_fkey;
       public          postgres    false    226    3287    232         �           2606    49343 (   categoria_subordinada sub_categoria_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.categoria_subordinada
    ADD CONSTRAINT sub_categoria_fkey FOREIGN KEY (codigo_sub_categoria) REFERENCES public.categoria(codigo_categoria) NOT VALID;
 R   ALTER TABLE ONLY public.categoria_subordinada DROP CONSTRAINT sub_categoria_fkey;
       public          postgres    false    215    213    3262         �           2606    49348 *   categoria_subordinada super_categoria_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.categoria_subordinada
    ADD CONSTRAINT super_categoria_fkey FOREIGN KEY (codigo_super_categoria) REFERENCES public.categoria(codigo_categoria) NOT VALID;
 T   ALTER TABLE ONLY public.categoria_subordinada DROP CONSTRAINT super_categoria_fkey;
       public          postgres    false    3262    213    215         �           2606    49353    emprestimo usuario_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.emprestimo
    ADD CONSTRAINT usuario_fkey FOREIGN KEY (codigo_usuario) REFERENCES public.usuario(codigo_usuario) NOT VALID;
 A   ALTER TABLE ONLY public.emprestimo DROP CONSTRAINT usuario_fkey;
       public          postgres    false    220    3290    234         �           2606    49358    endereco_usuario usuario_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.endereco_usuario
    ADD CONSTRAINT usuario_fkey FOREIGN KEY (codigo_usuario) REFERENCES public.usuario(codigo_usuario) NOT VALID;
 G   ALTER TABLE ONLY public.endereco_usuario DROP CONSTRAINT usuario_fkey;
       public          postgres    false    234    3290    223                                                                                                                                                                                                3450.dat                                                                                            0000600 0004000 0002000 00000000540 14274043535 0014253 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        INSERT INTO public.autor (codigo_autor, nome) VALUES (2, 'Autor 02');
INSERT INTO public.autor (codigo_autor, nome) VALUES (1, 'Autor 01');
INSERT INTO public.autor (codigo_autor, nome) VALUES (5, 'Autor 05');
INSERT INTO public.autor (codigo_autor, nome) VALUES (4, 'Autor 04');
INSERT INTO public.autor (codigo_autor, nome) VALUES (3, 'Autor 03');


                                                                                                                                                                3452.dat                                                                                            0000600 0004000 0002000 00000002142 14274043535 0014255 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        INSERT INTO public.bibliotecario (codigo_bibliotecario, nome, rg, cpf, nascimento, email, telefone) VALUES (1, 'Bibliotecario 01', '11.111.111-1', '111.111.111-11', '2001-01-01', 'bibliotecario01@gmail.com', '45911111111');
INSERT INTO public.bibliotecario (codigo_bibliotecario, nome, rg, cpf, nascimento, email, telefone) VALUES (2, 'Bibliotecario 02', '22.222.222-2', '222.222.222-22', '2002-02-02', 'bibliotecario02@gmail.com', '45922221111');
INSERT INTO public.bibliotecario (codigo_bibliotecario, nome, rg, cpf, nascimento, email, telefone) VALUES (3, 'Bibliotecario 03', '33.333.333-3', '333.333.333-33', '2003-03-03', 'bibliotecario03@gmail.com', '45933331111');
INSERT INTO public.bibliotecario (codigo_bibliotecario, nome, rg, cpf, nascimento, email, telefone) VALUES (4, 'Bibliotecario 04', '44.444.444-4', '444.444.444-44', '2004-04-04', 'bibliotecario04@gmail.com', '45944441111');
INSERT INTO public.bibliotecario (codigo_bibliotecario, nome, rg, cpf, nascimento, email, telefone) VALUES (5, 'Bibliotecario 05', '55.555.555-5', '555.555.555-55', '2005-05-05', 'bibliotecario05@gmail.com', '45955551111');


                                                                                                                                                                                                                                                                                                                                                                                                                              3454.dat                                                                                            0000600 0004000 0002000 00000000634 14274043535 0014263 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        INSERT INTO public.categoria (codigo_categoria, nome) VALUES (5, 'Categoria 05');
INSERT INTO public.categoria (codigo_categoria, nome) VALUES (4, 'Categoria 04');
INSERT INTO public.categoria (codigo_categoria, nome) VALUES (3, 'Categoria 03');
INSERT INTO public.categoria (codigo_categoria, nome) VALUES (2, 'Categoria 02');
INSERT INTO public.categoria (codigo_categoria, nome) VALUES (1, 'Categoria 01');


                                                                                                    3456.dat                                                                                            0000600 0004000 0002000 00000000467 14274043535 0014271 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        INSERT INTO public.categoria_subordinada (codigo_super_categoria, codigo_sub_categoria) VALUES (4, 5);
INSERT INTO public.categoria_subordinada (codigo_super_categoria, codigo_sub_categoria) VALUES (1, 3);
INSERT INTO public.categoria_subordinada (codigo_super_categoria, codigo_sub_categoria) VALUES (1, 2);


                                                                                                                                                                                                         3457.dat                                                                                            0000600 0004000 0002000 00000001474 14274043535 0014271 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        INSERT INTO public.devolucao (codigo_devolucao, data_devolucao, hora_devolucao, codigo_emprestimo, codigo_bibliotecario) VALUES (1, '2022-01-11', '10:00:00', 1, 4);
INSERT INTO public.devolucao (codigo_devolucao, data_devolucao, hora_devolucao, codigo_emprestimo, codigo_bibliotecario) VALUES (2, '2022-01-12', '10:00:00', 2, 4);
INSERT INTO public.devolucao (codigo_devolucao, data_devolucao, hora_devolucao, codigo_emprestimo, codigo_bibliotecario) VALUES (4, '2022-01-19', '10:00:00', 4, 5);
INSERT INTO public.devolucao (codigo_devolucao, data_devolucao, hora_devolucao, codigo_emprestimo, codigo_bibliotecario) VALUES (6, '2022-08-06', '15:58:23', 24, 5);
INSERT INTO public.devolucao (codigo_devolucao, data_devolucao, hora_devolucao, codigo_emprestimo, codigo_bibliotecario) VALUES (3, '2022-01-15', '10:00:00', 3, 4);


                                                                                                                                                                                                    3459.dat                                                                                            0000600 0004000 0002000 00000000576 14274043535 0014275 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        INSERT INTO public.editora (codigo_editora, nome) VALUES (5, 'Editora 05');
INSERT INTO public.editora (codigo_editora, nome) VALUES (4, 'Editora 04');
INSERT INTO public.editora (codigo_editora, nome) VALUES (3, 'Editora 03');
INSERT INTO public.editora (codigo_editora, nome) VALUES (2, 'Editora 02');
INSERT INTO public.editora (codigo_editora, nome) VALUES (1, 'Editora 01');


                                                                                                                                  3461.dat                                                                                            0000600 0004000 0002000 00000002373 14274043535 0014263 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        INSERT INTO public.emprestimo (codigo_emprestimo, data_emprestimo, hora_emprestimo, codigo_usuario, codigo_bibliotecario, codigo_exemplar, data_final) VALUES (1, '2022-01-01', '10:00:00', 1, 1, 1, '2022-01-11');
INSERT INTO public.emprestimo (codigo_emprestimo, data_emprestimo, hora_emprestimo, codigo_usuario, codigo_bibliotecario, codigo_exemplar, data_final) VALUES (2, '2022-01-02', '10:00:00', 2, 2, 2, '2022-01-12');
INSERT INTO public.emprestimo (codigo_emprestimo, data_emprestimo, hora_emprestimo, codigo_usuario, codigo_bibliotecario, codigo_exemplar, data_final) VALUES (4, '2022-01-04', '10:00:00', 4, 4, 4, '2022-01-14');
INSERT INTO public.emprestimo (codigo_emprestimo, data_emprestimo, hora_emprestimo, codigo_usuario, codigo_bibliotecario, codigo_exemplar, data_final) VALUES (5, '2022-01-05', '10:00:00', 5, 5, 5, '2022-01-15');
INSERT INTO public.emprestimo (codigo_emprestimo, data_emprestimo, hora_emprestimo, codigo_usuario, codigo_bibliotecario, codigo_exemplar, data_final) VALUES (3, '2022-01-03', '10:00:00', 3, 3, 3, '2022-01-13');
INSERT INTO public.emprestimo (codigo_emprestimo, data_emprestimo, hora_emprestimo, codigo_usuario, codigo_bibliotecario, codigo_exemplar, data_final) VALUES (24, '2022-08-06', '15:44:19', 1, 1, 1, '2022-08-16');


                                                                                                                                                                                                                                                                     3463.dat                                                                                            0000600 0004000 0002000 00000005405 14274043535 0014264 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        INSERT INTO public.endereco_bibliotecario (codigo_endereco_bibliotecario, codigo_bibliotecario, rotulo, logradouro, numero, complemento, bairro, cidade, estado, cep) VALUES (1, 1, 'Endereço Residencial', 'Rua 01', 1, 'Apartamento 01', 'Bairro 01', 'Cascavel', 'PR', '11.111-000');
INSERT INTO public.endereco_bibliotecario (codigo_endereco_bibliotecario, codigo_bibliotecario, rotulo, logradouro, numero, complemento, bairro, cidade, estado, cep) VALUES (1, 2, 'Endereço Residencial', 'Rua 03', 3, 'Apartamento 03', 'Bairro 03', 'Cascavel', 'PR', '33.333-000');
INSERT INTO public.endereco_bibliotecario (codigo_endereco_bibliotecario, codigo_bibliotecario, rotulo, logradouro, numero, complemento, bairro, cidade, estado, cep) VALUES (1, 3, 'Endereço Residencial', 'Rua 05', 5, 'Apartamento 05', 'Bairro 05', 'Corbelia', 'PR', '55.555-000');
INSERT INTO public.endereco_bibliotecario (codigo_endereco_bibliotecario, codigo_bibliotecario, rotulo, logradouro, numero, complemento, bairro, cidade, estado, cep) VALUES (1, 4, 'Endereço Residencial', 'Rua 07', 7, 'Apartamento 07', 'Bairro 07', 'Toledo', 'PR', '77.777-000');
INSERT INTO public.endereco_bibliotecario (codigo_endereco_bibliotecario, codigo_bibliotecario, rotulo, logradouro, numero, complemento, bairro, cidade, estado, cep) VALUES (1, 5, 'Endereço Residencial', 'Rua 09', 9, 'Apartamento 09', 'Bairro 09', 'Foz do Iguaçu', 'PR', '99.999-000');
INSERT INTO public.endereco_bibliotecario (codigo_endereco_bibliotecario, codigo_bibliotecario, rotulo, logradouro, numero, complemento, bairro, cidade, estado, cep) VALUES (2, 1, 'Endereço Comercial', 'Rua 02', 2, 'Apartamento 02', 'Bairro 02', 'Cascavel', 'PR', '22.222-000');
INSERT INTO public.endereco_bibliotecario (codigo_endereco_bibliotecario, codigo_bibliotecario, rotulo, logradouro, numero, complemento, bairro, cidade, estado, cep) VALUES (2, 2, 'Endereço Comercial', 'Rua 04', 4, 'Apartamento 04', 'Bairro 04', 'Corbelia', 'PR', '44.444-000');
INSERT INTO public.endereco_bibliotecario (codigo_endereco_bibliotecario, codigo_bibliotecario, rotulo, logradouro, numero, complemento, bairro, cidade, estado, cep) VALUES (2, 3, 'Endereço Comercial', 'Rua 06', 6, 'Apartamento 06', 'Bairro 06', 'Corbelia', 'PR', '66.666-000');
INSERT INTO public.endereco_bibliotecario (codigo_endereco_bibliotecario, codigo_bibliotecario, rotulo, logradouro, numero, complemento, bairro, cidade, estado, cep) VALUES (2, 4, 'Endereço Comercial', 'Rua 08', 8, 'Apartamento 08', 'Bairro 08', 'Toledo', 'PR', '88.888-000');
INSERT INTO public.endereco_bibliotecario (codigo_endereco_bibliotecario, codigo_bibliotecario, rotulo, logradouro, numero, complemento, bairro, cidade, estado, cep) VALUES (2, 5, 'Endereço Comercial', 'Rua 10', 10, 'Apartamento 10', 'Bairro 10', 'Foz do Iguaçu', 'PR', '10.000-000');


                                                                                                                                                                                                                                                           3464.dat                                                                                            0000600 0004000 0002000 00000006141 14274043535 0014263 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        INSERT INTO public.endereco_usuario (codigo_endereco_usuario, codigo_usuario, rotulo, logradouro, numero, complemento, bairro, cidade, estado, cep) VALUES (1, 1, 'Endereço Residencial', 'Rua 01', 1, 'Apartamento 01', 'Bairro 01', 'Cascavel', 'PR', '11.111-000');
INSERT INTO public.endereco_usuario (codigo_endereco_usuario, codigo_usuario, rotulo, logradouro, numero, complemento, bairro, cidade, estado, cep) VALUES (1, 2, 'Endereço Residencial', 'Rua 03', 3, 'Apartamento 03', 'Bairro 03', 'Cascavel', 'PR', '33.333-000');
INSERT INTO public.endereco_usuario (codigo_endereco_usuario, codigo_usuario, rotulo, logradouro, numero, complemento, bairro, cidade, estado, cep) VALUES (1, 3, 'Endereço Residencial', 'Rua 05', 5, 'Apartamento 05', 'Bairro 05', 'Corbelia', 'PR', '55.555-000');
INSERT INTO public.endereco_usuario (codigo_endereco_usuario, codigo_usuario, rotulo, logradouro, numero, complemento, bairro, cidade, estado, cep) VALUES (1, 4, 'Endereço Residencial', 'Rua 07', 7, 'Apartamento 07', 'Bairro 07', 'Toledo', 'PR', '77.777-000');
INSERT INTO public.endereco_usuario (codigo_endereco_usuario, codigo_usuario, rotulo, logradouro, numero, complemento, bairro, cidade, estado, cep) VALUES (1, 5, 'Endereço Residencial', 'Rua 09', 9, 'Apartamento 09', 'Bairro 09', 'Foz do Iguaçu', 'PR', '99.999-000');
INSERT INTO public.endereco_usuario (codigo_endereco_usuario, codigo_usuario, rotulo, logradouro, numero, complemento, bairro, cidade, estado, cep) VALUES (2, 1, 'Endereço Comercial', 'Rua 02', 2, 'Apartamento 02', 'Bairro 02', 'Cascavel', 'PR', '22.222-000');
INSERT INTO public.endereco_usuario (codigo_endereco_usuario, codigo_usuario, rotulo, logradouro, numero, complemento, bairro, cidade, estado, cep) VALUES (2, 2, 'Endereço Comercial', 'Rua 04', 4, 'Apartamento 04', 'Bairro 04', 'Corbelia', 'PR', '44.444-000');
INSERT INTO public.endereco_usuario (codigo_endereco_usuario, codigo_usuario, rotulo, logradouro, numero, complemento, bairro, cidade, estado, cep) VALUES (2, 3, 'Endereço Comercial', 'Rua 06', 6, 'Apartamento 06', 'Bairro 06', 'Corbelia', 'PR', '66.666-000');
INSERT INTO public.endereco_usuario (codigo_endereco_usuario, codigo_usuario, rotulo, logradouro, numero, complemento, bairro, cidade, estado, cep) VALUES (2, 4, 'Endereço Comercial', 'Rua 08', 8, 'Apartamento 08', 'Bairro 08', 'Toledo', 'PR', '88.888-000');
INSERT INTO public.endereco_usuario (codigo_endereco_usuario, codigo_usuario, rotulo, logradouro, numero, complemento, bairro, cidade, estado, cep) VALUES (2, 5, 'Endereço Comercial', 'Rua 10', 10, 'Apartamento 10', 'Bairro 10', 'Foz do Iguaçu', 'PR', '10.000-000');
INSERT INTO public.endereco_usuario (codigo_endereco_usuario, codigo_usuario, rotulo, logradouro, numero, complemento, bairro, cidade, estado, cep) VALUES (2, 6, 'Endereço comercial', 'Rua 12', 22, 'Apartamento 12', 'Bairro 12', 'Curitiba', 'PR', '12.000-000');
INSERT INTO public.endereco_usuario (codigo_endereco_usuario, codigo_usuario, rotulo, logradouro, numero, complemento, bairro, cidade, estado, cep) VALUES (1, 6, 'Endereço Residencial', 'Rua 11', 11, 'Apartamento 11', 'Bairro 11', 'Curitiba', 'PR', '11.000-000');


                                                                                                                                                                                                                                                                                                                                                                                                                               3465.dat                                                                                            0000600 0004000 0002000 00000000576 14274043535 0014272 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        INSERT INTO public.estante (codigo_estante, "Local") VALUES (1, 'Sala 01');
INSERT INTO public.estante (codigo_estante, "Local") VALUES (2, 'Sala 01');
INSERT INTO public.estante (codigo_estante, "Local") VALUES (3, 'Sala 02');
INSERT INTO public.estante (codigo_estante, "Local") VALUES (4, 'Sala 02');
INSERT INTO public.estante (codigo_estante, "Local") VALUES (5, 'Sala 03');


                                                                                                                                  3467.dat                                                                                            0000600 0004000 0002000 00000001430 14274043535 0014262 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        INSERT INTO public.estante_secao (codigo_estante, codigo_secao) VALUES (5, 4);
INSERT INTO public.estante_secao (codigo_estante, codigo_secao) VALUES (5, 2);
INSERT INTO public.estante_secao (codigo_estante, codigo_secao) VALUES (4, 3);
INSERT INTO public.estante_secao (codigo_estante, codigo_secao) VALUES (4, 1);
INSERT INTO public.estante_secao (codigo_estante, codigo_secao) VALUES (3, 5);
INSERT INTO public.estante_secao (codigo_estante, codigo_secao) VALUES (3, 4);
INSERT INTO public.estante_secao (codigo_estante, codigo_secao) VALUES (2, 3);
INSERT INTO public.estante_secao (codigo_estante, codigo_secao) VALUES (2, 2);
INSERT INTO public.estante_secao (codigo_estante, codigo_secao) VALUES (1, 2);
INSERT INTO public.estante_secao (codigo_estante, codigo_secao) VALUES (1, 1);


                                                                                                                                                                                                                                        3468.dat                                                                                            0000600 0004000 0002000 00000002701 14274043535 0014265 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        INSERT INTO public.exemplar (codigo_exemplar, data_aquisicao, descricao, isbn, codigo_estante) VALUES (1, '2000-01-01', 'Exemplar lote 01', 1, 1);
INSERT INTO public.exemplar (codigo_exemplar, data_aquisicao, descricao, isbn, codigo_estante) VALUES (2, '2000-01-01', 'Exemplar lote 01', 2, 2);
INSERT INTO public.exemplar (codigo_exemplar, data_aquisicao, descricao, isbn, codigo_estante) VALUES (3, '2000-01-01', 'Exemplar lote 01', 3, 3);
INSERT INTO public.exemplar (codigo_exemplar, data_aquisicao, descricao, isbn, codigo_estante) VALUES (4, '2000-01-01', 'Exemplar lote 01', 4, 4);
INSERT INTO public.exemplar (codigo_exemplar, data_aquisicao, descricao, isbn, codigo_estante) VALUES (5, '2000-01-01', 'Exemplar lote 01', 5, 5);
INSERT INTO public.exemplar (codigo_exemplar, data_aquisicao, descricao, isbn, codigo_estante) VALUES (6, '2000-01-02', 'Exemplar lote 02', 1, 1);
INSERT INTO public.exemplar (codigo_exemplar, data_aquisicao, descricao, isbn, codigo_estante) VALUES (7, '2000-01-02', 'Exemplar lote 02', 2, 2);
INSERT INTO public.exemplar (codigo_exemplar, data_aquisicao, descricao, isbn, codigo_estante) VALUES (8, '2000-01-02', 'Exemplar lote 02', 3, 3);
INSERT INTO public.exemplar (codigo_exemplar, data_aquisicao, descricao, isbn, codigo_estante) VALUES (9, '2000-01-02', 'Exemplar lote 02', 4, 4);
INSERT INTO public.exemplar (codigo_exemplar, data_aquisicao, descricao, isbn, codigo_estante) VALUES (10, '2000-01-02', 'Exemplar lote 02', 5, 5);


                                                               3470.dat                                                                                            0000600 0004000 0002000 00000001770 14274043535 0014263 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        INSERT INTO public.livro (isbn, data_publicacao, titulo, codigo_editora, codigo_categoria, idioma, codigo_autor) VALUES (3, '2000-01-03', 'Livro 03', 3, 5, 'PR-BR', 3);
INSERT INTO public.livro (isbn, data_publicacao, titulo, codigo_editora, codigo_categoria, idioma, codigo_autor) VALUES (4, '2000-01-04', 'Livro 04', 4, 2, 'PR-BR', 4);
INSERT INTO public.livro (isbn, data_publicacao, titulo, codigo_editora, codigo_categoria, idioma, codigo_autor) VALUES (5, '2000-01-05', 'Livro 05', 5, 3, 'PR-BR', 5);
INSERT INTO public.livro (isbn, data_publicacao, titulo, codigo_editora, codigo_categoria, idioma, codigo_autor) VALUES (1, '2000-01-01', 'Livro 01', 1, 2, 'EN-EN', 1);
INSERT INTO public.livro (isbn, data_publicacao, titulo, codigo_editora, codigo_categoria, idioma, codigo_autor) VALUES (2, '2000-01-02', 'Livro 02', 2, 3, 'EN-EN', 2);
INSERT INTO public.livro (isbn, data_publicacao, titulo, codigo_editora, codigo_categoria, idioma, codigo_autor) VALUES (6, '2000-01-06', 'Livro 06', 1, 2, 'EN-EN', 1);


        3471.dat                                                                                            0000600 0004000 0002000 00000000600 14274043535 0014253 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        INSERT INTO public.multa (codigo_multa, dias_atraso, valor, data_pagamento, hora_pagamento, codigo_emprestimo, codigo_bibliotecario) VALUES (2, 5, 'R$ 5,00', '2022-01-19', '10:00:00', 3, 2);
INSERT INTO public.multa (codigo_multa, dias_atraso, valor, data_pagamento, hora_pagamento, codigo_emprestimo, codigo_bibliotecario) VALUES (1, 2, 'R$ 2,00', '2022-01-15', '10:00:00', 4, 1);


                                                                                                                                3473.dat                                                                                            0000600 0004000 0002000 00000000552 14274043535 0014263 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        INSERT INTO public.secao (codigo_secao, nome) VALUES (5, 'Seção 05');
INSERT INTO public.secao (codigo_secao, nome) VALUES (4, 'Seção 04');
INSERT INTO public.secao (codigo_secao, nome) VALUES (3, 'Seção 03');
INSERT INTO public.secao (codigo_secao, nome) VALUES (2, 'Seção 02');
INSERT INTO public.secao (codigo_secao, nome) VALUES (1, 'Seção 01');


                                                                                                                                                      3475.dat                                                                                            0000600 0004000 0002000 00000002303 14274043535 0014261 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        INSERT INTO public.usuario (codigo_usuario, nome, nascimento, rg, cpf, email, telefone) VALUES (1, 'Usuário 01', '2000-01-01', '11.111.111-0', '111.111.111-00', 'usuario01@outlook.com', '45911110000');
INSERT INTO public.usuario (codigo_usuario, nome, nascimento, rg, cpf, email, telefone) VALUES (2, 'Usuário 02', '2000-01-02', '22.222.222-0', '222.222.222-00', 'usuario02@outlook.com', '45922220000');
INSERT INTO public.usuario (codigo_usuario, nome, nascimento, rg, cpf, email, telefone) VALUES (3, 'Usuário 03', '2000-01-03', '33.333.333-0', '333.333.333-00', 'usuario03@outlook.com', '45933330000');
INSERT INTO public.usuario (codigo_usuario, nome, nascimento, rg, cpf, email, telefone) VALUES (4, 'Usuário 04', '2000-01-04', '44.444.444-0', '444.444.444-00', 'usuario04@outlook.com', '45944440000');
INSERT INTO public.usuario (codigo_usuario, nome, nascimento, rg, cpf, email, telefone) VALUES (5, 'Usuário 05', '2000-01-05', '55.555.555-0', '555.555.555-00', 'usuario05@outlook.com', '45955550000');
INSERT INTO public.usuario (codigo_usuario, nome, nascimento, rg, cpf, email, telefone) VALUES (6, 'Usuario 06', '2000-01-06', '66.666.666-6', '666.666.666-66', 'usuario06@outlook.com', '45966660000');


                                                                                                                                                                                                                                                                                                                             restore.sql                                                                                         0000600 0004000 0002000 00000057561 14274043535 0015411 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        --
-- NOTE:
--
-- File paths need to be edited. Search for $$PATH$$ and
-- replace it with the path to the directory containing
-- the extracted data files.
--
--
-- PostgreSQL database dump
--

-- Dumped from database version 14.4
-- Dumped by pg_dump version 14.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE "Projeto-BD-Biblioteca";
--
-- Name: Projeto-BD-Biblioteca; Type: DATABASE; Schema: -; Owner: -
--

CREATE DATABASE "Projeto-BD-Biblioteca" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Portuguese_Brazil.1252';


\connect -reuse-previous=on "dbname='Projeto-BD-Biblioteca'"

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: checkemprestimopendencia(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.checkemprestimopendencia() RETURNS trigger
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


--
-- Name: deletecategoriasubordinada(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.deletecategoriasubordinada() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM categoria_subordinada
    WHERE codigo_super_categoria = OLD.codigo_categoria
    OR codigo_sub_categoria = OLD.codigo_categoria;
    RETURN OLD;
END;
$$;


--
-- Name: deletelivroexemplar(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.deletelivroexemplar() RETURNS trigger
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


--
-- Name: setnullemprestimoexemplar(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.setnullemprestimoexemplar() RETURNS trigger
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


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: autor; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.autor (
    codigo_autor integer NOT NULL,
    nome character varying(255)
)
WITH (autovacuum_enabled='true');


--
-- Name: autor_codigo_autor_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.autor_codigo_autor_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: autor_codigo_autor_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.autor_codigo_autor_seq OWNED BY public.autor.codigo_autor;


--
-- Name: bibliotecario_codigo_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bibliotecario_codigo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bibliotecario; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bibliotecario (
    codigo_bibliotecario integer DEFAULT nextval('public.bibliotecario_codigo_seq'::regclass) NOT NULL,
    nome character varying(255),
    rg character(12),
    cpf character(14),
    nascimento date,
    email character varying(100),
    telefone character varying
)
WITH (autovacuum_enabled='true');


--
-- Name: categoria_codigo_categoria_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.categoria_codigo_categoria_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categoria; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categoria (
    codigo_categoria integer DEFAULT nextval('public.categoria_codigo_categoria_seq'::regclass) NOT NULL,
    nome character varying(255)
)
WITH (autovacuum_enabled='true');


--
-- Name: categoria_subordinada; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categoria_subordinada (
    codigo_super_categoria integer NOT NULL,
    codigo_sub_categoria integer NOT NULL
)
WITH (autovacuum_enabled='true');


--
-- Name: devolucao; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.devolucao (
    codigo_devolucao integer NOT NULL,
    data_devolucao date DEFAULT CURRENT_DATE,
    hora_devolucao time without time zone DEFAULT CURRENT_TIMESTAMP(0),
    codigo_emprestimo integer,
    codigo_bibliotecario integer
)
WITH (autovacuum_enabled='true');


--
-- Name: devolucao_codigo_devolucao_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.devolucao_codigo_devolucao_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: devolucao_codigo_devolucao_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.devolucao_codigo_devolucao_seq OWNED BY public.devolucao.codigo_devolucao;


--
-- Name: editora_codigo_editora_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.editora_codigo_editora_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: editora; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.editora (
    codigo_editora integer DEFAULT nextval('public.editora_codigo_editora_seq'::regclass) NOT NULL,
    nome character varying(255)
)
WITH (autovacuum_enabled='true');


--
-- Name: emprestimo_codigo_emprestimo_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.emprestimo_codigo_emprestimo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: emprestimo; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.emprestimo (
    codigo_emprestimo integer DEFAULT nextval('public.emprestimo_codigo_emprestimo_seq'::regclass) NOT NULL,
    data_emprestimo date DEFAULT CURRENT_DATE,
    hora_emprestimo time without time zone DEFAULT CURRENT_TIMESTAMP(0),
    codigo_usuario integer,
    codigo_bibliotecario integer,
    codigo_exemplar integer,
    data_final date DEFAULT (CURRENT_DATE + 10)
)
WITH (autovacuum_enabled='true');


--
-- Name: endereco_bibliotecario; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.endereco_bibliotecario (
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
)
WITH (autovacuum_enabled='true');


--
-- Name: endereco_usuario; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.endereco_usuario (
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
)
WITH (autovacuum_enabled='true');


--
-- Name: estante_codigo_estante_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.estante_codigo_estante_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: estante; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.estante (
    codigo_estante integer DEFAULT nextval('public.estante_codigo_estante_seq'::regclass) NOT NULL,
    "Local" character varying(255)
)
WITH (autovacuum_enabled='true');


--
-- Name: estante_secao; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.estante_secao (
    codigo_estante integer NOT NULL,
    codigo_secao integer NOT NULL
)
WITH (autovacuum_enabled='true');


--
-- Name: exemplar_codigo_exemplar_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.exemplar_codigo_exemplar_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: exemplar; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.exemplar (
    codigo_exemplar integer DEFAULT nextval('public.exemplar_codigo_exemplar_seq'::regclass) NOT NULL,
    data_aquisicao date,
    descricao character varying(255),
    isbn bigint,
    codigo_estante integer
)
WITH (autovacuum_enabled='true');


--
-- Name: livro; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.livro (
    isbn bigint NOT NULL,
    data_publicacao date,
    titulo character varying(255),
    codigo_editora integer,
    codigo_categoria integer,
    idioma character varying(5),
    codigo_autor integer
)
WITH (autovacuum_enabled='true');


--
-- Name: multa; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.multa (
    codigo_multa integer NOT NULL,
    dias_atraso integer,
    valor money,
    data_pagamento date DEFAULT CURRENT_DATE,
    hora_pagamento time without time zone DEFAULT CURRENT_TIMESTAMP(0),
    codigo_emprestimo integer,
    codigo_bibliotecario integer
)
WITH (autovacuum_enabled='true');


--
-- Name: multa_codigo_multa_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.multa_codigo_multa_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: multa_codigo_multa_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.multa_codigo_multa_seq OWNED BY public.multa.codigo_multa;


--
-- Name: secao_codigo_secao_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.secao_codigo_secao_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: secao; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.secao (
    codigo_secao integer DEFAULT nextval('public.secao_codigo_secao_seq'::regclass) NOT NULL,
    nome character varying(255)
)
WITH (autovacuum_enabled='true');


--
-- Name: usuario_codigo_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.usuario_codigo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: usuario; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.usuario (
    codigo_usuario integer DEFAULT nextval('public.usuario_codigo_seq'::regclass) NOT NULL,
    nome character varying(255),
    nascimento date,
    rg character varying(12),
    cpf character varying(14),
    email character varying(100),
    telefone character varying
)
WITH (autovacuum_enabled='true');


--
-- Name: autor codigo_autor; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.autor ALTER COLUMN codigo_autor SET DEFAULT nextval('public.autor_codigo_autor_seq'::regclass);


--
-- Name: devolucao codigo_devolucao; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.devolucao ALTER COLUMN codigo_devolucao SET DEFAULT nextval('public.devolucao_codigo_devolucao_seq'::regclass);


--
-- Name: multa codigo_multa; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.multa ALTER COLUMN codigo_multa SET DEFAULT nextval('public.multa_codigo_multa_seq'::regclass);


--
-- Data for Name: autor; Type: TABLE DATA; Schema: public; Owner: -
--

\i $$PATH$$/3450.dat

--
-- Data for Name: bibliotecario; Type: TABLE DATA; Schema: public; Owner: -
--

\i $$PATH$$/3452.dat

--
-- Data for Name: categoria; Type: TABLE DATA; Schema: public; Owner: -
--

\i $$PATH$$/3454.dat

--
-- Data for Name: categoria_subordinada; Type: TABLE DATA; Schema: public; Owner: -
--

\i $$PATH$$/3456.dat

--
-- Data for Name: devolucao; Type: TABLE DATA; Schema: public; Owner: -
--

\i $$PATH$$/3457.dat

--
-- Data for Name: editora; Type: TABLE DATA; Schema: public; Owner: -
--

\i $$PATH$$/3459.dat

--
-- Data for Name: emprestimo; Type: TABLE DATA; Schema: public; Owner: -
--

\i $$PATH$$/3461.dat

--
-- Data for Name: endereco_bibliotecario; Type: TABLE DATA; Schema: public; Owner: -
--

\i $$PATH$$/3463.dat

--
-- Data for Name: endereco_usuario; Type: TABLE DATA; Schema: public; Owner: -
--

\i $$PATH$$/3464.dat

--
-- Data for Name: estante; Type: TABLE DATA; Schema: public; Owner: -
--

\i $$PATH$$/3465.dat

--
-- Data for Name: estante_secao; Type: TABLE DATA; Schema: public; Owner: -
--

\i $$PATH$$/3467.dat

--
-- Data for Name: exemplar; Type: TABLE DATA; Schema: public; Owner: -
--

\i $$PATH$$/3468.dat

--
-- Data for Name: livro; Type: TABLE DATA; Schema: public; Owner: -
--

\i $$PATH$$/3470.dat

--
-- Data for Name: multa; Type: TABLE DATA; Schema: public; Owner: -
--

\i $$PATH$$/3471.dat

--
-- Data for Name: secao; Type: TABLE DATA; Schema: public; Owner: -
--

\i $$PATH$$/3473.dat

--
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: -
--

\i $$PATH$$/3475.dat

--
-- Name: autor_codigo_autor_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.autor_codigo_autor_seq', 6, true);


--
-- Name: bibliotecario_codigo_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.bibliotecario_codigo_seq', 6, true);


--
-- Name: categoria_codigo_categoria_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.categoria_codigo_categoria_seq', 6, true);


--
-- Name: devolucao_codigo_devolucao_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.devolucao_codigo_devolucao_seq', 6, true);


--
-- Name: editora_codigo_editora_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.editora_codigo_editora_seq', 6, true);


--
-- Name: emprestimo_codigo_emprestimo_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.emprestimo_codigo_emprestimo_seq', 25, true);


--
-- Name: estante_codigo_estante_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.estante_codigo_estante_seq', 6, true);


--
-- Name: exemplar_codigo_exemplar_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.exemplar_codigo_exemplar_seq', 11, true);


--
-- Name: multa_codigo_multa_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.multa_codigo_multa_seq', 5, true);


--
-- Name: secao_codigo_secao_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.secao_codigo_secao_seq', 6, true);


--
-- Name: usuario_codigo_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.usuario_codigo_seq', 7, true);


--
-- Name: autor autor_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.autor
    ADD CONSTRAINT autor_pkey PRIMARY KEY (codigo_autor);


--
-- Name: bibliotecario bibliotecario_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bibliotecario
    ADD CONSTRAINT bibliotecario_pkey PRIMARY KEY (codigo_bibliotecario);


--
-- Name: categoria categoria_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categoria
    ADD CONSTRAINT categoria_pkey PRIMARY KEY (codigo_categoria);


--
-- Name: categoria_subordinada categoria_subordinada_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categoria_subordinada
    ADD CONSTRAINT categoria_subordinada_pkey PRIMARY KEY (codigo_super_categoria, codigo_sub_categoria);


--
-- Name: devolucao devolucao_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.devolucao
    ADD CONSTRAINT devolucao_pkey PRIMARY KEY (codigo_devolucao);


--
-- Name: editora editora_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.editora
    ADD CONSTRAINT editora_pkey PRIMARY KEY (codigo_editora);


--
-- Name: emprestimo emprestimo_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.emprestimo
    ADD CONSTRAINT emprestimo_pkey PRIMARY KEY (codigo_emprestimo);


--
-- Name: endereco_bibliotecario endereco_bibliotecario_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.endereco_bibliotecario
    ADD CONSTRAINT endereco_bibliotecario_pkey PRIMARY KEY (codigo_endereco_bibliotecario, codigo_bibliotecario);


--
-- Name: endereco_usuario endereco_usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.endereco_usuario
    ADD CONSTRAINT endereco_usuario_pkey PRIMARY KEY (codigo_endereco_usuario, codigo_usuario);


--
-- Name: estante estante_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.estante
    ADD CONSTRAINT estante_pkey PRIMARY KEY (codigo_estante);


--
-- Name: estante_secao estante_secao_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.estante_secao
    ADD CONSTRAINT estante_secao_pkey PRIMARY KEY (codigo_estante, codigo_secao);


--
-- Name: exemplar exemplar_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exemplar
    ADD CONSTRAINT exemplar_pkey PRIMARY KEY (codigo_exemplar);


--
-- Name: livro livro_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.livro
    ADD CONSTRAINT livro_pkey PRIMARY KEY (isbn);


--
-- Name: multa multa_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.multa
    ADD CONSTRAINT multa_pkey PRIMARY KEY (codigo_multa);


--
-- Name: secao secao_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.secao
    ADD CONSTRAINT secao_pkey PRIMARY KEY (codigo_secao);


--
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (codigo_usuario);


--
-- Name: unq_cpf_bib; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unq_cpf_bib ON public.bibliotecario USING btree (cpf);


--
-- Name: unq_cpf_usu; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unq_cpf_usu ON public.usuario USING btree (cpf);


--
-- Name: unq_isbn; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unq_isbn ON public.livro USING btree (isbn);


--
-- Name: emprestimo tg_checkemprestimopendencia; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_checkemprestimopendencia AFTER INSERT ON public.emprestimo FOR EACH STATEMENT EXECUTE FUNCTION public.checkemprestimopendencia();


--
-- Name: categoria tg_deletecategoriasubordinada; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_deletecategoriasubordinada BEFORE DELETE ON public.categoria FOR EACH ROW EXECUTE FUNCTION public.deletecategoriasubordinada();


--
-- Name: livro tg_deletelivroexemplar; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_deletelivroexemplar BEFORE DELETE ON public.livro FOR EACH ROW EXECUTE FUNCTION public.deletelivroexemplar();


--
-- Name: exemplar tg_setnullexemplar; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_setnullexemplar BEFORE DELETE ON public.exemplar FOR EACH ROW EXECUTE FUNCTION public.setnullemprestimoexemplar();


--
-- Name: livro autor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.livro
    ADD CONSTRAINT autor_fkey FOREIGN KEY (codigo_autor) REFERENCES public.autor(codigo_autor) NOT VALID;


--
-- Name: emprestimo bibliotecario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.emprestimo
    ADD CONSTRAINT bibliotecario_fkey FOREIGN KEY (codigo_bibliotecario) REFERENCES public.bibliotecario(codigo_bibliotecario) NOT VALID;


--
-- Name: endereco_bibliotecario bibliotecario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.endereco_bibliotecario
    ADD CONSTRAINT bibliotecario_fkey FOREIGN KEY (codigo_bibliotecario) REFERENCES public.bibliotecario(codigo_bibliotecario) NOT VALID;


--
-- Name: livro categoria_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.livro
    ADD CONSTRAINT categoria_fkey FOREIGN KEY (codigo_categoria) REFERENCES public.categoria(codigo_categoria) NOT VALID;


--
-- Name: livro editora_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.livro
    ADD CONSTRAINT editora_fkey FOREIGN KEY (codigo_editora) REFERENCES public.editora(codigo_editora) NOT VALID;


--
-- Name: multa emprestimo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.multa
    ADD CONSTRAINT emprestimo_fkey FOREIGN KEY (codigo_emprestimo) REFERENCES public.emprestimo(codigo_emprestimo) NOT VALID;


--
-- Name: devolucao emprestimo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.devolucao
    ADD CONSTRAINT emprestimo_fkey FOREIGN KEY (codigo_emprestimo) REFERENCES public.emprestimo(codigo_emprestimo) NOT VALID;


--
-- Name: estante_secao estante_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.estante_secao
    ADD CONSTRAINT estante_fkey FOREIGN KEY (codigo_estante) REFERENCES public.estante(codigo_estante) NOT VALID;


--
-- Name: exemplar estante_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exemplar
    ADD CONSTRAINT estante_fkey FOREIGN KEY (codigo_estante) REFERENCES public.estante(codigo_estante) NOT VALID;


--
-- Name: emprestimo exemplar_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.emprestimo
    ADD CONSTRAINT exemplar_fkey FOREIGN KEY (codigo_exemplar) REFERENCES public.exemplar(codigo_exemplar) NOT VALID;


--
-- Name: exemplar livro_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exemplar
    ADD CONSTRAINT livro_fkey FOREIGN KEY (isbn) REFERENCES public.livro(isbn) NOT VALID;


--
-- Name: estante_secao secao_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.estante_secao
    ADD CONSTRAINT secao_fkey FOREIGN KEY (codigo_secao) REFERENCES public.secao(codigo_secao) NOT VALID;


--
-- Name: categoria_subordinada sub_categoria_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categoria_subordinada
    ADD CONSTRAINT sub_categoria_fkey FOREIGN KEY (codigo_sub_categoria) REFERENCES public.categoria(codigo_categoria) NOT VALID;


--
-- Name: categoria_subordinada super_categoria_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categoria_subordinada
    ADD CONSTRAINT super_categoria_fkey FOREIGN KEY (codigo_super_categoria) REFERENCES public.categoria(codigo_categoria) NOT VALID;


--
-- Name: emprestimo usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.emprestimo
    ADD CONSTRAINT usuario_fkey FOREIGN KEY (codigo_usuario) REFERENCES public.usuario(codigo_usuario) NOT VALID;


--
-- Name: endereco_usuario usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.endereco_usuario
    ADD CONSTRAINT usuario_fkey FOREIGN KEY (codigo_usuario) REFERENCES public.usuario(codigo_usuario) NOT VALID;


--
-- PostgreSQL database dump complete
--

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               