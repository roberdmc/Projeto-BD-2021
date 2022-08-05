PGDMP     %                    z         
   Projeto BD    14.4    14.4 b    x           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            y           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            z           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            {           1262    32900 
   Projeto BD    DATABASE     l   CREATE DATABASE "Projeto BD" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Portuguese_Brazil.1252';
    DROP DATABASE "Projeto BD";
                postgres    false                        2615    32901 
   biblioteca    SCHEMA        CREATE SCHEMA biblioteca;
    DROP SCHEMA biblioteca;
                postgres    false            |           0    0    SCHEMA biblioteca    COMMENT     :   COMMENT ON SCHEMA biblioteca IS 'standard public schema';
                   postgres    false    5            �            1255    40995    checkemprestimopendencia()    FUNCTION     �  CREATE FUNCTION biblioteca.checkemprestimopendencia() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN IF
        (SELECT COUNT(*) AS pendencia_count 
                FROM ((SELECT e.codigo_usuario
                            FROM biblioteca.emprestimo e
                            FULL JOIN biblioteca.devolucao d ON d.codigo_emprestimo = e.codigo_emprestimo
                            WHERE e.data_emprestimo = CURRENT_DATE)
                        INTERSECT
                        (SELECT e.codigo_usuario
                            FROM biblioteca.emprestimo e
                            FULL JOIN biblioteca.devolucao d ON d.codigo_emprestimo = e.codigo_emprestimo
                            WHERE e.data_final < CURRENT_DATE
                            AND d.data_devolucao is NULL)) AS foo) > 0
    THEN RAISE EXCEPTION 'Atraso pendente identificado.';
    END IF; RETURN NEW; END$$;
 5   DROP FUNCTION biblioteca.checkemprestimopendencia();
    
   biblioteca          postgres    false    5            �            1255    40999    deletecategoriasubordinada()    FUNCTION     #  CREATE FUNCTION biblioteca.deletecategoriasubordinada() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM biblioteca.categoria_subordinada
    WHERE codigo_super_categoria = OLD.codigo_categoria
    OR codigo_sub_categoria = OLD.codigo_categoria;
    RETURN OLD;
END;
$$;
 7   DROP FUNCTION biblioteca.deletecategoriasubordinada();
    
   biblioteca          postgres    false    5            �            1255    40986    deletelivroexemplar()    FUNCTION     %  CREATE FUNCTION biblioteca.deletelivroexemplar() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM biblioteca.exemplar
    WHERE codigo_exemplar IN 
        (SELECT codigo_exemplar 
         FROM biblioteca.exemplar
         WHERE isbn = OLD.isbn);
    RETURN OLD;
END;
$$;
 0   DROP FUNCTION biblioteca.deletelivroexemplar();
    
   biblioteca          postgres    false    5            �            1255    40988    setnullemprestimoexemplar()    FUNCTION     \  CREATE FUNCTION biblioteca.setnullemprestimoexemplar() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE biblioteca.emprestimo
    SET codigo_exemplar = NULL
    WHERE codigo_exemplar IN
        (SELECT codigo_exemplar 
         FROM biblioteca.exemplar
         WHERE codigo_exemplar = OLD.codigo_exemplar);
    RETURN OLD;
END;
$$;
 6   DROP FUNCTION biblioteca.setnullemprestimoexemplar();
    
   biblioteca          postgres    false    5            �            1259    32902    autor    TABLE     a   CREATE TABLE biblioteca.autor (
    codigo_autor integer NOT NULL,
    nome character varying
);
    DROP TABLE biblioteca.autor;
    
   biblioteca         heap    postgres    false    5            �            1259    32907    autor_codigo_autor_seq    SEQUENCE     �   CREATE SEQUENCE biblioteca.autor_codigo_autor_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE biblioteca.autor_codigo_autor_seq;
    
   biblioteca          postgres    false    5    210            }           0    0    autor_codigo_autor_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE biblioteca.autor_codigo_autor_seq OWNED BY biblioteca.autor.codigo_autor;
       
   biblioteca          postgres    false    211            �            1259    32908    bibliotecario    TABLE     �   CREATE TABLE biblioteca.bibliotecario (
    codigo_bibliotecario integer NOT NULL,
    nome character varying,
    rg character(12),
    cpf character(14),
    nascimento date,
    telefone character varying[]
);
 %   DROP TABLE biblioteca.bibliotecario;
    
   biblioteca         heap    postgres    false    5            �            1259    32913    bibliotecario_codigo_seq    SEQUENCE     �   CREATE SEQUENCE biblioteca.bibliotecario_codigo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE biblioteca.bibliotecario_codigo_seq;
    
   biblioteca          postgres    false    212    5            ~           0    0    bibliotecario_codigo_seq    SEQUENCE OWNED BY     k   ALTER SEQUENCE biblioteca.bibliotecario_codigo_seq OWNED BY biblioteca.bibliotecario.codigo_bibliotecario;
       
   biblioteca          postgres    false    213            �            1259    32914 	   categoria    TABLE     i   CREATE TABLE biblioteca.categoria (
    codigo_categoria integer NOT NULL,
    nome character varying
);
 !   DROP TABLE biblioteca.categoria;
    
   biblioteca         heap    postgres    false    5            �            1259    32919    categoria_codigo_categoria_seq    SEQUENCE     �   CREATE SEQUENCE biblioteca.categoria_codigo_categoria_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 9   DROP SEQUENCE biblioteca.categoria_codigo_categoria_seq;
    
   biblioteca          postgres    false    5    214                       0    0    categoria_codigo_categoria_seq    SEQUENCE OWNED BY     i   ALTER SEQUENCE biblioteca.categoria_codigo_categoria_seq OWNED BY biblioteca.categoria.codigo_categoria;
       
   biblioteca          postgres    false    215            �            1259    32920    categoria_subordinada    TABLE     �   CREATE TABLE biblioteca.categoria_subordinada (
    codigo_super_categoria integer NOT NULL,
    codigo_sub_categoria integer NOT NULL
);
 -   DROP TABLE biblioteca.categoria_subordinada;
    
   biblioteca         heap    postgres    false    5            �            1259    32923 	   devolucao    TABLE     �   CREATE TABLE biblioteca.devolucao (
    codigo_devolucao integer NOT NULL,
    data_devolucao date DEFAULT CURRENT_DATE,
    hora_devolucao time without time zone DEFAULT CURRENT_TIMESTAMP(0),
    codigo_emprestimo integer
);
 !   DROP TABLE biblioteca.devolucao;
    
   biblioteca         heap    postgres    false    5            �            1259    32926    devolucao_codigo_devolucao_seq    SEQUENCE     �   CREATE SEQUENCE biblioteca.devolucao_codigo_devolucao_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 9   DROP SEQUENCE biblioteca.devolucao_codigo_devolucao_seq;
    
   biblioteca          postgres    false    5    217            �           0    0    devolucao_codigo_devolucao_seq    SEQUENCE OWNED BY     i   ALTER SEQUENCE biblioteca.devolucao_codigo_devolucao_seq OWNED BY biblioteca.devolucao.codigo_devolucao;
       
   biblioteca          postgres    false    218            �            1259    32927    editora    TABLE     e   CREATE TABLE biblioteca.editora (
    codigo_editora integer NOT NULL,
    nome character varying
);
    DROP TABLE biblioteca.editora;
    
   biblioteca         heap    postgres    false    5            �            1259    32932    editora_codigo_editora_seq    SEQUENCE     �   CREATE SEQUENCE biblioteca.editora_codigo_editora_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE biblioteca.editora_codigo_editora_seq;
    
   biblioteca          postgres    false    5    219            �           0    0    editora_codigo_editora_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE biblioteca.editora_codigo_editora_seq OWNED BY biblioteca.editora.codigo_editora;
       
   biblioteca          postgres    false    220            �            1259    32933 
   emprestimo    TABLE     S  CREATE TABLE biblioteca.emprestimo (
    codigo_emprestimo integer NOT NULL,
    data_emprestimo date DEFAULT CURRENT_DATE,
    hora_emprestimo time without time zone DEFAULT CURRENT_TIMESTAMP(0),
    codigo_usuario integer,
    codigo_bibliotecario integer,
    codigo_exemplar integer,
    data_final date DEFAULT (CURRENT_DATE + 10)
);
 "   DROP TABLE biblioteca.emprestimo;
    
   biblioteca         heap    postgres    false    5            �            1259    32936     emprestimo_codigo_emprestimo_seq    SEQUENCE     �   CREATE SEQUENCE biblioteca.emprestimo_codigo_emprestimo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ;   DROP SEQUENCE biblioteca.emprestimo_codigo_emprestimo_seq;
    
   biblioteca          postgres    false    5    221            �           0    0     emprestimo_codigo_emprestimo_seq    SEQUENCE OWNED BY     m   ALTER SEQUENCE biblioteca.emprestimo_codigo_emprestimo_seq OWNED BY biblioteca.emprestimo.codigo_emprestimo;
       
   biblioteca          postgres    false    222            �            1259    32937    endereco_bibliotecario    TABLE     z  CREATE TABLE biblioteca.endereco_bibliotecario (
    codigo_endereco_bibliotecario integer NOT NULL,
    codigo_bibliotecario integer NOT NULL,
    rotulo character varying,
    logradouro character varying,
    numero integer,
    complemento character varying,
    bairro character varying,
    cidade character varying,
    estado character varying,
    cep character(10)
);
 .   DROP TABLE biblioteca.endereco_bibliotecario;
    
   biblioteca         heap    postgres    false    5            �            1259    32942 8   endereco_bibliotecario_codigo_endereco_bibliotecario_seq    SEQUENCE     �   CREATE SEQUENCE biblioteca.endereco_bibliotecario_codigo_endereco_bibliotecario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 S   DROP SEQUENCE biblioteca.endereco_bibliotecario_codigo_endereco_bibliotecario_seq;
    
   biblioteca          postgres    false    5    223            �           0    0 8   endereco_bibliotecario_codigo_endereco_bibliotecario_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE biblioteca.endereco_bibliotecario_codigo_endereco_bibliotecario_seq OWNED BY biblioteca.endereco_bibliotecario.codigo_endereco_bibliotecario;
       
   biblioteca          postgres    false    224            �            1259    32943    endereco_usuario    TABLE     h  CREATE TABLE biblioteca.endereco_usuario (
    codigo_endereco_usuario integer NOT NULL,
    codigo_usuario integer NOT NULL,
    rotulo character varying,
    logradouro character varying,
    numero integer,
    complemento character varying,
    bairro character varying,
    cidade character varying,
    estado character varying,
    cep character(10)
);
 (   DROP TABLE biblioteca.endereco_usuario;
    
   biblioteca         heap    postgres    false    5            �            1259    32948 $   endereco_usuario_codigo_endereco_seq    SEQUENCE     �   CREATE SEQUENCE biblioteca.endereco_usuario_codigo_endereco_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ?   DROP SEQUENCE biblioteca.endereco_usuario_codigo_endereco_seq;
    
   biblioteca          postgres    false    5    225            �           0    0 $   endereco_usuario_codigo_endereco_seq    SEQUENCE OWNED BY     }   ALTER SEQUENCE biblioteca.endereco_usuario_codigo_endereco_seq OWNED BY biblioteca.endereco_usuario.codigo_endereco_usuario;
       
   biblioteca          postgres    false    226            �            1259    32949    estante    TABLE     e   CREATE TABLE biblioteca.estante (
    codigo_estante integer NOT NULL,
    nome character varying
);
    DROP TABLE biblioteca.estante;
    
   biblioteca         heap    postgres    false    5            �            1259    32954    estante_codigo_estante_seq    SEQUENCE     �   CREATE SEQUENCE biblioteca.estante_codigo_estante_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE biblioteca.estante_codigo_estante_seq;
    
   biblioteca          postgres    false    5    227            �           0    0    estante_codigo_estante_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE biblioteca.estante_codigo_estante_seq OWNED BY biblioteca.estante.codigo_estante;
       
   biblioteca          postgres    false    228            �            1259    32955    estante_secao    TABLE     r   CREATE TABLE biblioteca.estante_secao (
    codigo_estante integer NOT NULL,
    codigo_secao integer NOT NULL
);
 %   DROP TABLE biblioteca.estante_secao;
    
   biblioteca         heap    postgres    false    5            �            1259    32958    exemplar    TABLE     �   CREATE TABLE biblioteca.exemplar (
    codigo_exemplar integer NOT NULL,
    data_aquisicao date,
    descricao character varying,
    isbn bigint
);
     DROP TABLE biblioteca.exemplar;
    
   biblioteca         heap    postgres    false    5            �            1259    32963    exemplar_codigo_exemplar_seq    SEQUENCE     �   CREATE SEQUENCE biblioteca.exemplar_codigo_exemplar_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 7   DROP SEQUENCE biblioteca.exemplar_codigo_exemplar_seq;
    
   biblioteca          postgres    false    5    230            �           0    0    exemplar_codigo_exemplar_seq    SEQUENCE OWNED BY     e   ALTER SEQUENCE biblioteca.exemplar_codigo_exemplar_seq OWNED BY biblioteca.exemplar.codigo_exemplar;
       
   biblioteca          postgres    false    231            �            1259    32964    livro    TABLE     �   CREATE TABLE biblioteca.livro (
    isbn bigint NOT NULL,
    palavras_chave character varying[],
    data_publicacao date,
    titulo character varying,
    codigo_editora integer,
    codigo_categoria integer
);
    DROP TABLE biblioteca.livro;
    
   biblioteca         heap    postgres    false    5            �            1259    32969    multa    TABLE     �   CREATE TABLE biblioteca.multa (
    codigo_multa integer NOT NULL,
    dias_atraso integer,
    valor money,
    data_pagamento date,
    hora_pagamento time without time zone,
    codigo_emprestimo integer
);
    DROP TABLE biblioteca.multa;
    
   biblioteca         heap    postgres    false    5            �            1259    32972    multa_codigo_multa_seq    SEQUENCE     �   CREATE SEQUENCE biblioteca.multa_codigo_multa_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE biblioteca.multa_codigo_multa_seq;
    
   biblioteca          postgres    false    5    233            �           0    0    multa_codigo_multa_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE biblioteca.multa_codigo_multa_seq OWNED BY biblioteca.multa.codigo_multa;
       
   biblioteca          postgres    false    234            �            1259    32973    secao    TABLE     a   CREATE TABLE biblioteca.secao (
    codigo_secao integer NOT NULL,
    nome character varying
);
    DROP TABLE biblioteca.secao;
    
   biblioteca         heap    postgres    false    5            �            1259    32978    secao_codigo_secao_seq    SEQUENCE     �   CREATE SEQUENCE biblioteca.secao_codigo_secao_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE biblioteca.secao_codigo_secao_seq;
    
   biblioteca          postgres    false    5    235            �           0    0    secao_codigo_secao_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE biblioteca.secao_codigo_secao_seq OWNED BY biblioteca.secao.codigo_secao;
       
   biblioteca          postgres    false    236            �            1259    32979    usuario    TABLE     �   CREATE TABLE biblioteca.usuario (
    codigo_usuario integer NOT NULL,
    nome character varying,
    telefone character varying,
    nascimento date,
    rg character varying,
    cpf character varying
);
    DROP TABLE biblioteca.usuario;
    
   biblioteca         heap    postgres    false    5            �            1259    32984    usuario_codigo_seq    SEQUENCE     �   CREATE SEQUENCE biblioteca.usuario_codigo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE biblioteca.usuario_codigo_seq;
    
   biblioteca          postgres    false    5    237            �           0    0    usuario_codigo_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE biblioteca.usuario_codigo_seq OWNED BY biblioteca.usuario.codigo_usuario;
       
   biblioteca          postgres    false    238            �           2604    32985    autor codigo_autor    DEFAULT     �   ALTER TABLE ONLY biblioteca.autor ALTER COLUMN codigo_autor SET DEFAULT nextval('biblioteca.autor_codigo_autor_seq'::regclass);
 E   ALTER TABLE biblioteca.autor ALTER COLUMN codigo_autor DROP DEFAULT;
    
   biblioteca          postgres    false    211    210            �           2604    32986 "   bibliotecario codigo_bibliotecario    DEFAULT     �   ALTER TABLE ONLY biblioteca.bibliotecario ALTER COLUMN codigo_bibliotecario SET DEFAULT nextval('biblioteca.bibliotecario_codigo_seq'::regclass);
 U   ALTER TABLE biblioteca.bibliotecario ALTER COLUMN codigo_bibliotecario DROP DEFAULT;
    
   biblioteca          postgres    false    213    212            �           2604    32987    categoria codigo_categoria    DEFAULT     �   ALTER TABLE ONLY biblioteca.categoria ALTER COLUMN codigo_categoria SET DEFAULT nextval('biblioteca.categoria_codigo_categoria_seq'::regclass);
 M   ALTER TABLE biblioteca.categoria ALTER COLUMN codigo_categoria DROP DEFAULT;
    
   biblioteca          postgres    false    215    214            �           2604    32988    devolucao codigo_devolucao    DEFAULT     �   ALTER TABLE ONLY biblioteca.devolucao ALTER COLUMN codigo_devolucao SET DEFAULT nextval('biblioteca.devolucao_codigo_devolucao_seq'::regclass);
 M   ALTER TABLE biblioteca.devolucao ALTER COLUMN codigo_devolucao DROP DEFAULT;
    
   biblioteca          postgres    false    218    217            �           2604    32989    editora codigo_editora    DEFAULT     �   ALTER TABLE ONLY biblioteca.editora ALTER COLUMN codigo_editora SET DEFAULT nextval('biblioteca.editora_codigo_editora_seq'::regclass);
 I   ALTER TABLE biblioteca.editora ALTER COLUMN codigo_editora DROP DEFAULT;
    
   biblioteca          postgres    false    220    219            �           2604    32990    emprestimo codigo_emprestimo    DEFAULT     �   ALTER TABLE ONLY biblioteca.emprestimo ALTER COLUMN codigo_emprestimo SET DEFAULT nextval('biblioteca.emprestimo_codigo_emprestimo_seq'::regclass);
 O   ALTER TABLE biblioteca.emprestimo ALTER COLUMN codigo_emprestimo DROP DEFAULT;
    
   biblioteca          postgres    false    222    221            �           2604    32991 4   endereco_bibliotecario codigo_endereco_bibliotecario    DEFAULT     �   ALTER TABLE ONLY biblioteca.endereco_bibliotecario ALTER COLUMN codigo_endereco_bibliotecario SET DEFAULT nextval('biblioteca.endereco_bibliotecario_codigo_endereco_bibliotecario_seq'::regclass);
 g   ALTER TABLE biblioteca.endereco_bibliotecario ALTER COLUMN codigo_endereco_bibliotecario DROP DEFAULT;
    
   biblioteca          postgres    false    224    223            �           2604    32992 (   endereco_usuario codigo_endereco_usuario    DEFAULT     �   ALTER TABLE ONLY biblioteca.endereco_usuario ALTER COLUMN codigo_endereco_usuario SET DEFAULT nextval('biblioteca.endereco_usuario_codigo_endereco_seq'::regclass);
 [   ALTER TABLE biblioteca.endereco_usuario ALTER COLUMN codigo_endereco_usuario DROP DEFAULT;
    
   biblioteca          postgres    false    226    225            �           2604    32993    estante codigo_estante    DEFAULT     �   ALTER TABLE ONLY biblioteca.estante ALTER COLUMN codigo_estante SET DEFAULT nextval('biblioteca.estante_codigo_estante_seq'::regclass);
 I   ALTER TABLE biblioteca.estante ALTER COLUMN codigo_estante DROP DEFAULT;
    
   biblioteca          postgres    false    228    227            �           2604    32994    exemplar codigo_exemplar    DEFAULT     �   ALTER TABLE ONLY biblioteca.exemplar ALTER COLUMN codigo_exemplar SET DEFAULT nextval('biblioteca.exemplar_codigo_exemplar_seq'::regclass);
 K   ALTER TABLE biblioteca.exemplar ALTER COLUMN codigo_exemplar DROP DEFAULT;
    
   biblioteca          postgres    false    231    230            �           2604    32995    multa codigo_multa    DEFAULT     �   ALTER TABLE ONLY biblioteca.multa ALTER COLUMN codigo_multa SET DEFAULT nextval('biblioteca.multa_codigo_multa_seq'::regclass);
 E   ALTER TABLE biblioteca.multa ALTER COLUMN codigo_multa DROP DEFAULT;
    
   biblioteca          postgres    false    234    233            �           2604    32996    secao codigo_secao    DEFAULT     �   ALTER TABLE ONLY biblioteca.secao ALTER COLUMN codigo_secao SET DEFAULT nextval('biblioteca.secao_codigo_secao_seq'::regclass);
 E   ALTER TABLE biblioteca.secao ALTER COLUMN codigo_secao DROP DEFAULT;
    
   biblioteca          postgres    false    236    235            �           2604    32997    usuario codigo_usuario    DEFAULT     �   ALTER TABLE ONLY biblioteca.usuario ALTER COLUMN codigo_usuario SET DEFAULT nextval('biblioteca.usuario_codigo_seq'::regclass);
 I   ALTER TABLE biblioteca.usuario ALTER COLUMN codigo_usuario DROP DEFAULT;
    
   biblioteca          postgres    false    238    237            �           2606    32999    autor autor_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY biblioteca.autor
    ADD CONSTRAINT autor_pkey PRIMARY KEY (codigo_autor);
 >   ALTER TABLE ONLY biblioteca.autor DROP CONSTRAINT autor_pkey;
    
   biblioteca            postgres    false    210            �           2606    33001     bibliotecario bibliotecario_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY biblioteca.bibliotecario
    ADD CONSTRAINT bibliotecario_pkey PRIMARY KEY (codigo_bibliotecario);
 N   ALTER TABLE ONLY biblioteca.bibliotecario DROP CONSTRAINT bibliotecario_pkey;
    
   biblioteca            postgres    false    212            �           2606    33003    categoria categoria_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY biblioteca.categoria
    ADD CONSTRAINT categoria_pkey PRIMARY KEY (codigo_categoria);
 F   ALTER TABLE ONLY biblioteca.categoria DROP CONSTRAINT categoria_pkey;
    
   biblioteca            postgres    false    214            �           2606    33005 0   categoria_subordinada categoria_subordinada_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY biblioteca.categoria_subordinada
    ADD CONSTRAINT categoria_subordinada_pkey PRIMARY KEY (codigo_super_categoria, codigo_sub_categoria);
 ^   ALTER TABLE ONLY biblioteca.categoria_subordinada DROP CONSTRAINT categoria_subordinada_pkey;
    
   biblioteca            postgres    false    216    216            �           2606    33009    editora editora_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY biblioteca.editora
    ADD CONSTRAINT editora_pkey PRIMARY KEY (codigo_editora);
 B   ALTER TABLE ONLY biblioteca.editora DROP CONSTRAINT editora_pkey;
    
   biblioteca            postgres    false    219            �           2606    33011    emprestimo emprestimo_pkey 
   CONSTRAINT     k   ALTER TABLE ONLY biblioteca.emprestimo
    ADD CONSTRAINT emprestimo_pkey PRIMARY KEY (codigo_emprestimo);
 H   ALTER TABLE ONLY biblioteca.emprestimo DROP CONSTRAINT emprestimo_pkey;
    
   biblioteca            postgres    false    221            �           2606    33013 2   endereco_bibliotecario endereco_bibliotecario_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY biblioteca.endereco_bibliotecario
    ADD CONSTRAINT endereco_bibliotecario_pkey PRIMARY KEY (codigo_endereco_bibliotecario, codigo_bibliotecario);
 `   ALTER TABLE ONLY biblioteca.endereco_bibliotecario DROP CONSTRAINT endereco_bibliotecario_pkey;
    
   biblioteca            postgres    false    223    223            �           2606    33015 &   endereco_usuario endereco_usuario_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY biblioteca.endereco_usuario
    ADD CONSTRAINT endereco_usuario_pkey PRIMARY KEY (codigo_endereco_usuario, codigo_usuario);
 T   ALTER TABLE ONLY biblioteca.endereco_usuario DROP CONSTRAINT endereco_usuario_pkey;
    
   biblioteca            postgres    false    225    225            �           2606    33017    estante estante_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY biblioteca.estante
    ADD CONSTRAINT estante_pkey PRIMARY KEY (codigo_estante);
 B   ALTER TABLE ONLY biblioteca.estante DROP CONSTRAINT estante_pkey;
    
   biblioteca            postgres    false    227            �           2606    33019     estante_secao estante_secao_pkey 
   CONSTRAINT     |   ALTER TABLE ONLY biblioteca.estante_secao
    ADD CONSTRAINT estante_secao_pkey PRIMARY KEY (codigo_estante, codigo_secao);
 N   ALTER TABLE ONLY biblioteca.estante_secao DROP CONSTRAINT estante_secao_pkey;
    
   biblioteca            postgres    false    229    229            �           2606    33021    exemplar exemplar_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY biblioteca.exemplar
    ADD CONSTRAINT exemplar_pkey PRIMARY KEY (codigo_exemplar);
 D   ALTER TABLE ONLY biblioteca.exemplar DROP CONSTRAINT exemplar_pkey;
    
   biblioteca            postgres    false    230            �           2606    33023    livro livro_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY biblioteca.livro
    ADD CONSTRAINT livro_pkey PRIMARY KEY (isbn);
 >   ALTER TABLE ONLY biblioteca.livro DROP CONSTRAINT livro_pkey;
    
   biblioteca            postgres    false    232            �           2606    41009    multa multa_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY biblioteca.multa
    ADD CONSTRAINT multa_pkey PRIMARY KEY (codigo_multa);
 >   ALTER TABLE ONLY biblioteca.multa DROP CONSTRAINT multa_pkey;
    
   biblioteca            postgres    false    233            �           2606    33027    secao secao_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY biblioteca.secao
    ADD CONSTRAINT secao_pkey PRIMARY KEY (codigo_secao);
 >   ALTER TABLE ONLY biblioteca.secao DROP CONSTRAINT secao_pkey;
    
   biblioteca            postgres    false    235            �           2606    33029    usuario usuario_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY biblioteca.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (codigo_usuario);
 B   ALTER TABLE ONLY biblioteca.usuario DROP CONSTRAINT usuario_pkey;
    
   biblioteca            postgres    false    237            �           2620    40996 &   emprestimo tg_checkemprestimopendencia    TRIGGER     �   CREATE TRIGGER tg_checkemprestimopendencia AFTER INSERT ON biblioteca.emprestimo FOR EACH STATEMENT EXECUTE FUNCTION biblioteca.checkemprestimopendencia();
 C   DROP TRIGGER tg_checkemprestimopendencia ON biblioteca.emprestimo;
    
   biblioteca          postgres    false    221    253            �           2620    41001 '   categoria tg_deletecategoriasubordinada    TRIGGER     �   CREATE TRIGGER tg_deletecategoriasubordinada BEFORE DELETE ON biblioteca.categoria FOR EACH ROW EXECUTE FUNCTION biblioteca.deletecategoriasubordinada();
 D   DROP TRIGGER tg_deletecategoriasubordinada ON biblioteca.categoria;
    
   biblioteca          postgres    false    241    214            �           2620    40987    livro tg_deletelivroexemplar    TRIGGER     �   CREATE TRIGGER tg_deletelivroexemplar BEFORE DELETE ON biblioteca.livro FOR EACH ROW EXECUTE FUNCTION biblioteca.deletelivroexemplar();
 9   DROP TRIGGER tg_deletelivroexemplar ON biblioteca.livro;
    
   biblioteca          postgres    false    239    232            �           2620    40990    exemplar tg_setnullexemplar    TRIGGER     �   CREATE TRIGGER tg_setnullexemplar BEFORE DELETE ON biblioteca.exemplar FOR EACH ROW EXECUTE FUNCTION biblioteca.setnullemprestimoexemplar();
 8   DROP TRIGGER tg_setnullexemplar ON biblioteca.exemplar;
    
   biblioteca          postgres    false    230    240            �           2606    33030    emprestimo bibliotecario_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY biblioteca.emprestimo
    ADD CONSTRAINT bibliotecario_fkey FOREIGN KEY (codigo_bibliotecario) REFERENCES biblioteca.bibliotecario(codigo_bibliotecario) NOT VALID;
 K   ALTER TABLE ONLY biblioteca.emprestimo DROP CONSTRAINT bibliotecario_fkey;
    
   biblioteca          postgres    false    3262    221    212            �           2606    33116 )   endereco_bibliotecario bibliotecario_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY biblioteca.endereco_bibliotecario
    ADD CONSTRAINT bibliotecario_fkey FOREIGN KEY (codigo_bibliotecario) REFERENCES biblioteca.bibliotecario(codigo_bibliotecario) NOT VALID;
 W   ALTER TABLE ONLY biblioteca.endereco_bibliotecario DROP CONSTRAINT bibliotecario_fkey;
    
   biblioteca          postgres    false    3262    212    223            �           2606    33040    livro categoria_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY biblioteca.livro
    ADD CONSTRAINT categoria_fkey FOREIGN KEY (codigo_categoria) REFERENCES biblioteca.categoria(codigo_categoria) NOT VALID;
 B   ALTER TABLE ONLY biblioteca.livro DROP CONSTRAINT categoria_fkey;
    
   biblioteca          postgres    false    214    232    3264            �           2606    33045    livro editora_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY biblioteca.livro
    ADD CONSTRAINT editora_fkey FOREIGN KEY (codigo_editora) REFERENCES biblioteca.editora(codigo_editora) NOT VALID;
 @   ALTER TABLE ONLY biblioteca.livro DROP CONSTRAINT editora_fkey;
    
   biblioteca          postgres    false    3268    219    232            �           2606    41010    multa emprestimo_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY biblioteca.multa
    ADD CONSTRAINT emprestimo_fkey FOREIGN KEY (codigo_emprestimo) REFERENCES biblioteca.emprestimo(codigo_emprestimo) NOT VALID;
 C   ALTER TABLE ONLY biblioteca.multa DROP CONSTRAINT emprestimo_fkey;
    
   biblioteca          postgres    false    233    221    3270            �           2606    41015    devolucao emprestimo_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY biblioteca.devolucao
    ADD CONSTRAINT emprestimo_fkey FOREIGN KEY (codigo_emprestimo) REFERENCES biblioteca.emprestimo(codigo_emprestimo) NOT VALID;
 G   ALTER TABLE ONLY biblioteca.devolucao DROP CONSTRAINT emprestimo_fkey;
    
   biblioteca          postgres    false    221    3270    217            �           2606    33126    estante_secao estante_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY biblioteca.estante_secao
    ADD CONSTRAINT estante_fkey FOREIGN KEY (codigo_estante) REFERENCES biblioteca.estante(codigo_estante) NOT VALID;
 H   ALTER TABLE ONLY biblioteca.estante_secao DROP CONSTRAINT estante_fkey;
    
   biblioteca          postgres    false    3276    229    227            �           2606    33111    emprestimo exemplar_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY biblioteca.emprestimo
    ADD CONSTRAINT exemplar_fkey FOREIGN KEY (codigo_exemplar) REFERENCES biblioteca.exemplar(codigo_exemplar) NOT VALID;
 F   ALTER TABLE ONLY biblioteca.emprestimo DROP CONSTRAINT exemplar_fkey;
    
   biblioteca          postgres    false    230    221    3280            �           2606    33136    exemplar livro_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY biblioteca.exemplar
    ADD CONSTRAINT livro_fkey FOREIGN KEY (isbn) REFERENCES biblioteca.livro(isbn) NOT VALID;
 A   ALTER TABLE ONLY biblioteca.exemplar DROP CONSTRAINT livro_fkey;
    
   biblioteca          postgres    false    230    232    3282            �           2606    33131    estante_secao secao_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY biblioteca.estante_secao
    ADD CONSTRAINT secao_fkey FOREIGN KEY (codigo_secao) REFERENCES biblioteca.secao(codigo_secao) NOT VALID;
 F   ALTER TABLE ONLY biblioteca.estante_secao DROP CONSTRAINT secao_fkey;
    
   biblioteca          postgres    false    235    3286    229            �           2606    33101 (   categoria_subordinada sub_categoria_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY biblioteca.categoria_subordinada
    ADD CONSTRAINT sub_categoria_fkey FOREIGN KEY (codigo_sub_categoria) REFERENCES biblioteca.categoria(codigo_categoria) NOT VALID;
 V   ALTER TABLE ONLY biblioteca.categoria_subordinada DROP CONSTRAINT sub_categoria_fkey;
    
   biblioteca          postgres    false    214    216    3264            �           2606    33106 *   categoria_subordinada super_categoria_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY biblioteca.categoria_subordinada
    ADD CONSTRAINT super_categoria_fkey FOREIGN KEY (codigo_super_categoria) REFERENCES biblioteca.categoria(codigo_categoria) NOT VALID;
 X   ALTER TABLE ONLY biblioteca.categoria_subordinada DROP CONSTRAINT super_categoria_fkey;
    
   biblioteca          postgres    false    216    214    3264            �           2606    33090    emprestimo usuario_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY biblioteca.emprestimo
    ADD CONSTRAINT usuario_fkey FOREIGN KEY (codigo_usuario) REFERENCES biblioteca.usuario(codigo_usuario) NOT VALID;
 E   ALTER TABLE ONLY biblioteca.emprestimo DROP CONSTRAINT usuario_fkey;
    
   biblioteca          postgres    false    221    237    3288            �           2606    33121    endereco_usuario usuario_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY biblioteca.endereco_usuario
    ADD CONSTRAINT usuario_fkey FOREIGN KEY (codigo_usuario) REFERENCES biblioteca.usuario(codigo_usuario) NOT VALID;
 K   ALTER TABLE ONLY biblioteca.endereco_usuario DROP CONSTRAINT usuario_fkey;
    
   biblioteca          postgres    false    225    237    3288           