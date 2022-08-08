--
-- PostgreSQL database dump
--

-- Dumped from database version 14.4
-- Dumped by pg_dump version 14.4

--
-- TOC entry 250 (class 1255 OID 49154)
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
-- TOC entry 249 (class 1255 OID 49155)
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
-- TOC entry 247 (class 1255 OID 49156)
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
-- TOC entry 248 (class 1255 OID 49157)
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
-- TOC entry 209 (class 1259 OID 49158)
-- Name: autor; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.autor (
    codigo_autor integer NOT NULL,
    nome character varying(255)
)
WITH (autovacuum_enabled='true');


--
-- TOC entry 210 (class 1259 OID 49163)
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
-- TOC entry 3482 (class 0 OID 0)
-- Dependencies: 210
-- Name: autor_codigo_autor_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.autor_codigo_autor_seq OWNED BY public.autor.codigo_autor;


--
-- TOC entry 212 (class 1259 OID 49169)
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
-- TOC entry 211 (class 1259 OID 49164)
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
-- TOC entry 214 (class 1259 OID 49175)
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
-- TOC entry 213 (class 1259 OID 49170)
-- Name: categoria; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categoria (
    codigo_categoria integer DEFAULT nextval('public.categoria_codigo_categoria_seq'::regclass) NOT NULL,
    nome character varying(255)
)
WITH (autovacuum_enabled='true');


--
-- TOC entry 215 (class 1259 OID 49176)
-- Name: categoria_subordinada; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categoria_subordinada (
    codigo_super_categoria integer NOT NULL,
    codigo_sub_categoria integer NOT NULL
)
WITH (autovacuum_enabled='true');


--
-- TOC entry 216 (class 1259 OID 49179)
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
-- TOC entry 217 (class 1259 OID 49184)
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
-- TOC entry 3483 (class 0 OID 0)
-- Dependencies: 217
-- Name: devolucao_codigo_devolucao_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.devolucao_codigo_devolucao_seq OWNED BY public.devolucao.codigo_devolucao;


--
-- TOC entry 219 (class 1259 OID 49190)
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
-- TOC entry 218 (class 1259 OID 49185)
-- Name: editora; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.editora (
    codigo_editora integer DEFAULT nextval('public.editora_codigo_editora_seq'::regclass) NOT NULL,
    nome character varying(255)
)
WITH (autovacuum_enabled='true');


--
-- TOC entry 221 (class 1259 OID 49197)
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
-- TOC entry 220 (class 1259 OID 49191)
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
-- TOC entry 222 (class 1259 OID 49198)
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
-- TOC entry 223 (class 1259 OID 49204)
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
-- TOC entry 225 (class 1259 OID 49215)
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
-- TOC entry 224 (class 1259 OID 49210)
-- Name: estante; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.estante (
    codigo_estante integer DEFAULT nextval('public.estante_codigo_estante_seq'::regclass) NOT NULL,
    "Local" character varying(255)
)
WITH (autovacuum_enabled='true');


--
-- TOC entry 226 (class 1259 OID 49216)
-- Name: estante_secao; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.estante_secao (
    codigo_estante integer NOT NULL,
    codigo_secao integer NOT NULL
)
WITH (autovacuum_enabled='true');


--
-- TOC entry 228 (class 1259 OID 49224)
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
-- TOC entry 227 (class 1259 OID 49219)
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
-- TOC entry 229 (class 1259 OID 49225)
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
-- TOC entry 230 (class 1259 OID 49230)
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
-- TOC entry 231 (class 1259 OID 49233)
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
-- TOC entry 3484 (class 0 OID 0)
-- Dependencies: 231
-- Name: multa_codigo_multa_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.multa_codigo_multa_seq OWNED BY public.multa.codigo_multa;


--
-- TOC entry 233 (class 1259 OID 49239)
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
-- TOC entry 232 (class 1259 OID 49234)
-- Name: secao; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.secao (
    codigo_secao integer DEFAULT nextval('public.secao_codigo_secao_seq'::regclass) NOT NULL,
    nome character varying(255)
)
WITH (autovacuum_enabled='true');


--
-- TOC entry 235 (class 1259 OID 49245)
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
-- TOC entry 234 (class 1259 OID 49240)
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
-- TOC entry 3238 (class 2604 OID 49246)
-- Name: autor codigo_autor; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.autor ALTER COLUMN codigo_autor SET DEFAULT nextval('public.autor_codigo_autor_seq'::regclass);


--
-- TOC entry 3243 (class 2604 OID 49249)
-- Name: devolucao codigo_devolucao; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.devolucao ALTER COLUMN codigo_devolucao SET DEFAULT nextval('public.devolucao_codigo_devolucao_seq'::regclass);


--
-- TOC entry 3251 (class 2604 OID 49256)
-- Name: multa codigo_multa; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.multa ALTER COLUMN codigo_multa SET DEFAULT nextval('public.multa_codigo_multa_seq'::regclass);


--
-- TOC entry 3450 (class 0 OID 49158)
-- Dependencies: 209
-- Data for Name: autor; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.autor (codigo_autor, nome) VALUES (2, 'Autor 02');
INSERT INTO public.autor (codigo_autor, nome) VALUES (1, 'Autor 01');
INSERT INTO public.autor (codigo_autor, nome) VALUES (5, 'Autor 05');
INSERT INTO public.autor (codigo_autor, nome) VALUES (4, 'Autor 04');
INSERT INTO public.autor (codigo_autor, nome) VALUES (3, 'Autor 03');


--
-- TOC entry 3452 (class 0 OID 49164)
-- Dependencies: 211
-- Data for Name: bibliotecario; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.bibliotecario (codigo_bibliotecario, nome, rg, cpf, nascimento, email, telefone) VALUES (1, 'Bibliotecario 01', '11.111.111-1', '111.111.111-11', '2001-01-01', 'bibliotecario01@gmail.com', '45911111111');
INSERT INTO public.bibliotecario (codigo_bibliotecario, nome, rg, cpf, nascimento, email, telefone) VALUES (2, 'Bibliotecario 02', '22.222.222-2', '222.222.222-22', '2002-02-02', 'bibliotecario02@gmail.com', '45922221111');
INSERT INTO public.bibliotecario (codigo_bibliotecario, nome, rg, cpf, nascimento, email, telefone) VALUES (3, 'Bibliotecario 03', '33.333.333-3', '333.333.333-33', '2003-03-03', 'bibliotecario03@gmail.com', '45933331111');
INSERT INTO public.bibliotecario (codigo_bibliotecario, nome, rg, cpf, nascimento, email, telefone) VALUES (4, 'Bibliotecario 04', '44.444.444-4', '444.444.444-44', '2004-04-04', 'bibliotecario04@gmail.com', '45944441111');
INSERT INTO public.bibliotecario (codigo_bibliotecario, nome, rg, cpf, nascimento, email, telefone) VALUES (5, 'Bibliotecario 05', '55.555.555-5', '555.555.555-55', '2005-05-05', 'bibliotecario05@gmail.com', '45955551111');


--
-- TOC entry 3454 (class 0 OID 49170)
-- Dependencies: 213
-- Data for Name: categoria; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.categoria (codigo_categoria, nome) VALUES (5, 'Categoria 05');
INSERT INTO public.categoria (codigo_categoria, nome) VALUES (4, 'Categoria 04');
INSERT INTO public.categoria (codigo_categoria, nome) VALUES (3, 'Categoria 03');
INSERT INTO public.categoria (codigo_categoria, nome) VALUES (2, 'Categoria 02');
INSERT INTO public.categoria (codigo_categoria, nome) VALUES (1, 'Categoria 01');


--
-- TOC entry 3456 (class 0 OID 49176)
-- Dependencies: 215
-- Data for Name: categoria_subordinada; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.categoria_subordinada (codigo_super_categoria, codigo_sub_categoria) VALUES (4, 5);
INSERT INTO public.categoria_subordinada (codigo_super_categoria, codigo_sub_categoria) VALUES (1, 3);
INSERT INTO public.categoria_subordinada (codigo_super_categoria, codigo_sub_categoria) VALUES (1, 2);


--
-- TOC entry 3457 (class 0 OID 49179)
-- Dependencies: 216
-- Data for Name: devolucao; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.devolucao (codigo_devolucao, data_devolucao, hora_devolucao, codigo_emprestimo, codigo_bibliotecario) VALUES (1, '2022-01-11', '10:00:00', 1, 4);
INSERT INTO public.devolucao (codigo_devolucao, data_devolucao, hora_devolucao, codigo_emprestimo, codigo_bibliotecario) VALUES (2, '2022-01-12', '10:00:00', 2, 4);
INSERT INTO public.devolucao (codigo_devolucao, data_devolucao, hora_devolucao, codigo_emprestimo, codigo_bibliotecario) VALUES (4, '2022-01-19', '10:00:00', 4, 5);
INSERT INTO public.devolucao (codigo_devolucao, data_devolucao, hora_devolucao, codigo_emprestimo, codigo_bibliotecario) VALUES (6, '2022-08-06', '15:58:23', 24, 5);
INSERT INTO public.devolucao (codigo_devolucao, data_devolucao, hora_devolucao, codigo_emprestimo, codigo_bibliotecario) VALUES (3, '2022-01-15', '10:00:00', 3, 4);


--
-- TOC entry 3459 (class 0 OID 49185)
-- Dependencies: 218
-- Data for Name: editora; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.editora (codigo_editora, nome) VALUES (5, 'Editora 05');
INSERT INTO public.editora (codigo_editora, nome) VALUES (4, 'Editora 04');
INSERT INTO public.editora (codigo_editora, nome) VALUES (3, 'Editora 03');
INSERT INTO public.editora (codigo_editora, nome) VALUES (2, 'Editora 02');
INSERT INTO public.editora (codigo_editora, nome) VALUES (1, 'Editora 01');


--
-- TOC entry 3461 (class 0 OID 49191)
-- Dependencies: 220
-- Data for Name: emprestimo; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.emprestimo (codigo_emprestimo, data_emprestimo, hora_emprestimo, codigo_usuario, codigo_bibliotecario, codigo_exemplar, data_final) VALUES (1, '2022-01-01', '10:00:00', 1, 1, 1, '2022-01-11');
INSERT INTO public.emprestimo (codigo_emprestimo, data_emprestimo, hora_emprestimo, codigo_usuario, codigo_bibliotecario, codigo_exemplar, data_final) VALUES (2, '2022-01-02', '10:00:00', 2, 2, 2, '2022-01-12');
INSERT INTO public.emprestimo (codigo_emprestimo, data_emprestimo, hora_emprestimo, codigo_usuario, codigo_bibliotecario, codigo_exemplar, data_final) VALUES (4, '2022-01-04', '10:00:00', 4, 4, 4, '2022-01-14');
INSERT INTO public.emprestimo (codigo_emprestimo, data_emprestimo, hora_emprestimo, codigo_usuario, codigo_bibliotecario, codigo_exemplar, data_final) VALUES (5, '2022-01-05', '10:00:00', 5, 5, 5, '2022-01-15');
INSERT INTO public.emprestimo (codigo_emprestimo, data_emprestimo, hora_emprestimo, codigo_usuario, codigo_bibliotecario, codigo_exemplar, data_final) VALUES (3, '2022-01-03', '10:00:00', 3, 3, 3, '2022-01-13');
INSERT INTO public.emprestimo (codigo_emprestimo, data_emprestimo, hora_emprestimo, codigo_usuario, codigo_bibliotecario, codigo_exemplar, data_final) VALUES (24, '2022-08-06', '15:44:19', 1, 1, 1, '2022-08-16');


--
-- TOC entry 3463 (class 0 OID 49198)
-- Dependencies: 222
-- Data for Name: endereco_bibliotecario; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.endereco_bibliotecario (codigo_endereco_bibliotecario, codigo_bibliotecario, rotulo, logradouro, numero, complemento, bairro, cidade, estado, cep) VALUES (1, 1, 'Endereço Residencial', 'Rua 01', 1, 'Apartamento 01', 'Bairro 01', 'Cascavel', 'PR', '11.111-000');
INSERT INTO public.endereco_bibliotecario (codigo_endereco_bibliotecario, codigo_bibliotecario, rotulo, logradouro, numero, complemento, bairro, cidade, estado, cep) VALUES (1, 2, 'Endereço Residencial', 'Rua 03', 3, 'Apartamento 03', 'Bairro 03', 'Cascavel', 'PR', '33.333-000');
INSERT INTO public.endereco_bibliotecario (codigo_endereco_bibliotecario, codigo_bibliotecario, rotulo, logradouro, numero, complemento, bairro, cidade, estado, cep) VALUES (1, 3, 'Endereço Residencial', 'Rua 05', 5, 'Apartamento 05', 'Bairro 05', 'Corbelia', 'PR', '55.555-000');
INSERT INTO public.endereco_bibliotecario (codigo_endereco_bibliotecario, codigo_bibliotecario, rotulo, logradouro, numero, complemento, bairro, cidade, estado, cep) VALUES (1, 4, 'Endereço Residencial', 'Rua 07', 7, 'Apartamento 07', 'Bairro 07', 'Toledo', 'PR', '77.777-000');
INSERT INTO public.endereco_bibliotecario (codigo_endereco_bibliotecario, codigo_bibliotecario, rotulo, logradouro, numero, complemento, bairro, cidade, estado, cep) VALUES (1, 5, 'Endereço Residencial', 'Rua 09', 9, 'Apartamento 09', 'Bairro 09', 'Foz do Iguaçu', 'PR', '99.999-000');
INSERT INTO public.endereco_bibliotecario (codigo_endereco_bibliotecario, codigo_bibliotecario, rotulo, logradouro, numero, complemento, bairro, cidade, estado, cep) VALUES (2, 1, 'Endereço Comercial', 'Rua 02', 2, 'Apartamento 02', 'Bairro 02', 'Cascavel', 'PR', '22.222-000');
INSERT INTO public.endereco_bibliotecario (codigo_endereco_bibliotecario, codigo_bibliotecario, rotulo, logradouro, numero, complemento, bairro, cidade, estado, cep) VALUES (2, 2, 'Endereço Comercial', 'Rua 04', 4, 'Apartamento 04', 'Bairro 04', 'Corbelia', 'PR', '44.444-000');
INSERT INTO public.endereco_bibliotecario (codigo_endereco_bibliotecario, codigo_bibliotecario, rotulo, logradouro, numero, complemento, bairro, cidade, estado, cep) VALUES (2, 3, 'Endereço Comercial', 'Rua 06', 6, 'Apartamento 06', 'Bairro 06', 'Corbelia', 'PR', '66.666-000');
INSERT INTO public.endereco_bibliotecario (codigo_endereco_bibliotecario, codigo_bibliotecario, rotulo, logradouro, numero, complemento, bairro, cidade, estado, cep) VALUES (2, 4, 'Endereço Comercial', 'Rua 08', 8, 'Apartamento 08', 'Bairro 08', 'Toledo', 'PR', '88.888-000');
INSERT INTO public.endereco_bibliotecario (codigo_endereco_bibliotecario, codigo_bibliotecario, rotulo, logradouro, numero, complemento, bairro, cidade, estado, cep) VALUES (2, 5, 'Endereço Comercial', 'Rua 10', 10, 'Apartamento 10', 'Bairro 10', 'Foz do Iguaçu', 'PR', '10.000-000');


--
-- TOC entry 3464 (class 0 OID 49204)
-- Dependencies: 223
-- Data for Name: endereco_usuario; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.endereco_usuario (codigo_endereco_usuario, codigo_usuario, rotulo, logradouro, numero, complemento, bairro, cidade, estado, cep) VALUES (1, 1, 'Endereço Residencial', 'Rua 01', 1, 'Apartamento 01', 'Bairro 01', 'Cascavel', 'PR', '11.111-000');
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


--
-- TOC entry 3465 (class 0 OID 49210)
-- Dependencies: 224
-- Data for Name: estante; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.estante (codigo_estante, "Local") VALUES (1, 'Sala 01');
INSERT INTO public.estante (codigo_estante, "Local") VALUES (2, 'Sala 01');
INSERT INTO public.estante (codigo_estante, "Local") VALUES (3, 'Sala 02');
INSERT INTO public.estante (codigo_estante, "Local") VALUES (4, 'Sala 02');
INSERT INTO public.estante (codigo_estante, "Local") VALUES (5, 'Sala 03');


--
-- TOC entry 3467 (class 0 OID 49216)
-- Dependencies: 226
-- Data for Name: estante_secao; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.estante_secao (codigo_estante, codigo_secao) VALUES (5, 4);
INSERT INTO public.estante_secao (codigo_estante, codigo_secao) VALUES (5, 2);
INSERT INTO public.estante_secao (codigo_estante, codigo_secao) VALUES (4, 3);
INSERT INTO public.estante_secao (codigo_estante, codigo_secao) VALUES (4, 1);
INSERT INTO public.estante_secao (codigo_estante, codigo_secao) VALUES (3, 5);
INSERT INTO public.estante_secao (codigo_estante, codigo_secao) VALUES (3, 4);
INSERT INTO public.estante_secao (codigo_estante, codigo_secao) VALUES (2, 3);
INSERT INTO public.estante_secao (codigo_estante, codigo_secao) VALUES (2, 2);
INSERT INTO public.estante_secao (codigo_estante, codigo_secao) VALUES (1, 2);
INSERT INTO public.estante_secao (codigo_estante, codigo_secao) VALUES (1, 1);


--
-- TOC entry 3468 (class 0 OID 49219)
-- Dependencies: 227
-- Data for Name: exemplar; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.exemplar (codigo_exemplar, data_aquisicao, descricao, isbn, codigo_estante) VALUES (1, '2000-01-01', 'Exemplar lote 01', 1, 1);
INSERT INTO public.exemplar (codigo_exemplar, data_aquisicao, descricao, isbn, codigo_estante) VALUES (2, '2000-01-01', 'Exemplar lote 01', 2, 2);
INSERT INTO public.exemplar (codigo_exemplar, data_aquisicao, descricao, isbn, codigo_estante) VALUES (3, '2000-01-01', 'Exemplar lote 01', 3, 3);
INSERT INTO public.exemplar (codigo_exemplar, data_aquisicao, descricao, isbn, codigo_estante) VALUES (4, '2000-01-01', 'Exemplar lote 01', 4, 4);
INSERT INTO public.exemplar (codigo_exemplar, data_aquisicao, descricao, isbn, codigo_estante) VALUES (5, '2000-01-01', 'Exemplar lote 01', 5, 5);
INSERT INTO public.exemplar (codigo_exemplar, data_aquisicao, descricao, isbn, codigo_estante) VALUES (6, '2000-01-02', 'Exemplar lote 02', 1, 1);
INSERT INTO public.exemplar (codigo_exemplar, data_aquisicao, descricao, isbn, codigo_estante) VALUES (7, '2000-01-02', 'Exemplar lote 02', 2, 2);
INSERT INTO public.exemplar (codigo_exemplar, data_aquisicao, descricao, isbn, codigo_estante) VALUES (8, '2000-01-02', 'Exemplar lote 02', 3, 3);
INSERT INTO public.exemplar (codigo_exemplar, data_aquisicao, descricao, isbn, codigo_estante) VALUES (9, '2000-01-02', 'Exemplar lote 02', 4, 4);
INSERT INTO public.exemplar (codigo_exemplar, data_aquisicao, descricao, isbn, codigo_estante) VALUES (10, '2000-01-02', 'Exemplar lote 02', 5, 5);


--
-- TOC entry 3470 (class 0 OID 49225)
-- Dependencies: 229
-- Data for Name: livro; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.livro (isbn, data_publicacao, titulo, codigo_editora, codigo_categoria, idioma, codigo_autor) VALUES (3, '2000-01-03', 'Livro 03', 3, 5, 'PR-BR', 3);
INSERT INTO public.livro (isbn, data_publicacao, titulo, codigo_editora, codigo_categoria, idioma, codigo_autor) VALUES (4, '2000-01-04', 'Livro 04', 4, 2, 'PR-BR', 4);
INSERT INTO public.livro (isbn, data_publicacao, titulo, codigo_editora, codigo_categoria, idioma, codigo_autor) VALUES (5, '2000-01-05', 'Livro 05', 5, 3, 'PR-BR', 5);
INSERT INTO public.livro (isbn, data_publicacao, titulo, codigo_editora, codigo_categoria, idioma, codigo_autor) VALUES (1, '2000-01-01', 'Livro 01', 1, 2, 'EN-EN', 1);
INSERT INTO public.livro (isbn, data_publicacao, titulo, codigo_editora, codigo_categoria, idioma, codigo_autor) VALUES (2, '2000-01-02', 'Livro 02', 2, 3, 'EN-EN', 2);
INSERT INTO public.livro (isbn, data_publicacao, titulo, codigo_editora, codigo_categoria, idioma, codigo_autor) VALUES (6, '2000-01-06', 'Livro 06', 1, 2, 'EN-EN', 1);


--
-- TOC entry 3471 (class 0 OID 49230)
-- Dependencies: 230
-- Data for Name: multa; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.multa (codigo_multa, dias_atraso, valor, data_pagamento, hora_pagamento, codigo_emprestimo, codigo_bibliotecario) VALUES (2, 5, 'R$ 5,00', '2022-01-19', '10:00:00', 3, 2);
INSERT INTO public.multa (codigo_multa, dias_atraso, valor, data_pagamento, hora_pagamento, codigo_emprestimo, codigo_bibliotecario) VALUES (1, 2, 'R$ 2,00', '2022-01-15', '10:00:00', 4, 1);


--
-- TOC entry 3473 (class 0 OID 49234)
-- Dependencies: 232
-- Data for Name: secao; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.secao (codigo_secao, nome) VALUES (5, 'Seção 05');
INSERT INTO public.secao (codigo_secao, nome) VALUES (4, 'Seção 04');
INSERT INTO public.secao (codigo_secao, nome) VALUES (3, 'Seção 03');
INSERT INTO public.secao (codigo_secao, nome) VALUES (2, 'Seção 02');
INSERT INTO public.secao (codigo_secao, nome) VALUES (1, 'Seção 01');


--
-- TOC entry 3475 (class 0 OID 49240)
-- Dependencies: 234
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.usuario (codigo_usuario, nome, nascimento, rg, cpf, email, telefone) VALUES (1, 'Usuário 01', '2000-01-01', '11.111.111-0', '111.111.111-00', 'usuario01@outlook.com', '45911110000');
INSERT INTO public.usuario (codigo_usuario, nome, nascimento, rg, cpf, email, telefone) VALUES (2, 'Usuário 02', '2000-01-02', '22.222.222-0', '222.222.222-00', 'usuario02@outlook.com', '45922220000');
INSERT INTO public.usuario (codigo_usuario, nome, nascimento, rg, cpf, email, telefone) VALUES (3, 'Usuário 03', '2000-01-03', '33.333.333-0', '333.333.333-00', 'usuario03@outlook.com', '45933330000');
INSERT INTO public.usuario (codigo_usuario, nome, nascimento, rg, cpf, email, telefone) VALUES (4, 'Usuário 04', '2000-01-04', '44.444.444-0', '444.444.444-00', 'usuario04@outlook.com', '45944440000');
INSERT INTO public.usuario (codigo_usuario, nome, nascimento, rg, cpf, email, telefone) VALUES (5, 'Usuário 05', '2000-01-05', '55.555.555-0', '555.555.555-00', 'usuario05@outlook.com', '45955550000');
INSERT INTO public.usuario (codigo_usuario, nome, nascimento, rg, cpf, email, telefone) VALUES (6, 'Usuario 06', '2000-01-06', '66.666.666-6', '666.666.666-66', 'usuario06@outlook.com', '45966660000');


--
-- TOC entry 3485 (class 0 OID 0)
-- Dependencies: 210
-- Name: autor_codigo_autor_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.autor_codigo_autor_seq', 6, true);


--
-- TOC entry 3486 (class 0 OID 0)
-- Dependencies: 212
-- Name: bibliotecario_codigo_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.bibliotecario_codigo_seq', 6, true);


--
-- TOC entry 3487 (class 0 OID 0)
-- Dependencies: 214
-- Name: categoria_codigo_categoria_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.categoria_codigo_categoria_seq', 6, true);


--
-- TOC entry 3488 (class 0 OID 0)
-- Dependencies: 217
-- Name: devolucao_codigo_devolucao_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.devolucao_codigo_devolucao_seq', 6, true);


--
-- TOC entry 3489 (class 0 OID 0)
-- Dependencies: 219
-- Name: editora_codigo_editora_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.editora_codigo_editora_seq', 6, true);


--
-- TOC entry 3490 (class 0 OID 0)
-- Dependencies: 221
-- Name: emprestimo_codigo_emprestimo_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.emprestimo_codigo_emprestimo_seq', 25, true);


--
-- TOC entry 3491 (class 0 OID 0)
-- Dependencies: 225
-- Name: estante_codigo_estante_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.estante_codigo_estante_seq', 6, true);


--
-- TOC entry 3492 (class 0 OID 0)
-- Dependencies: 228
-- Name: exemplar_codigo_exemplar_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.exemplar_codigo_exemplar_seq', 11, true);


--
-- TOC entry 3493 (class 0 OID 0)
-- Dependencies: 231
-- Name: multa_codigo_multa_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.multa_codigo_multa_seq', 5, true);


--
-- TOC entry 3494 (class 0 OID 0)
-- Dependencies: 233
-- Name: secao_codigo_secao_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.secao_codigo_secao_seq', 6, true);


--
-- TOC entry 3495 (class 0 OID 0)
-- Dependencies: 235
-- Name: usuario_codigo_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.usuario_codigo_seq', 7, true);


--
-- TOC entry 3257 (class 2606 OID 49260)
-- Name: autor autor_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.autor
    ADD CONSTRAINT autor_pkey PRIMARY KEY (codigo_autor);


--
-- TOC entry 3259 (class 2606 OID 49262)
-- Name: bibliotecario bibliotecario_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bibliotecario
    ADD CONSTRAINT bibliotecario_pkey PRIMARY KEY (codigo_bibliotecario);


--
-- TOC entry 3262 (class 2606 OID 49264)
-- Name: categoria categoria_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categoria
    ADD CONSTRAINT categoria_pkey PRIMARY KEY (codigo_categoria);


--
-- TOC entry 3264 (class 2606 OID 49266)
-- Name: categoria_subordinada categoria_subordinada_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categoria_subordinada
    ADD CONSTRAINT categoria_subordinada_pkey PRIMARY KEY (codigo_super_categoria, codigo_sub_categoria);


--
-- TOC entry 3266 (class 2606 OID 49557)
-- Name: devolucao devolucao_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.devolucao
    ADD CONSTRAINT devolucao_pkey PRIMARY KEY (codigo_devolucao);


--
-- TOC entry 3268 (class 2606 OID 49268)
-- Name: editora editora_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.editora
    ADD CONSTRAINT editora_pkey PRIMARY KEY (codigo_editora);


--
-- TOC entry 3270 (class 2606 OID 49270)
-- Name: emprestimo emprestimo_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.emprestimo
    ADD CONSTRAINT emprestimo_pkey PRIMARY KEY (codigo_emprestimo);


--
-- TOC entry 3272 (class 2606 OID 49272)
-- Name: endereco_bibliotecario endereco_bibliotecario_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.endereco_bibliotecario
    ADD CONSTRAINT endereco_bibliotecario_pkey PRIMARY KEY (codigo_endereco_bibliotecario, codigo_bibliotecario);


--
-- TOC entry 3274 (class 2606 OID 49274)
-- Name: endereco_usuario endereco_usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.endereco_usuario
    ADD CONSTRAINT endereco_usuario_pkey PRIMARY KEY (codigo_endereco_usuario, codigo_usuario);


--
-- TOC entry 3276 (class 2606 OID 49276)
-- Name: estante estante_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.estante
    ADD CONSTRAINT estante_pkey PRIMARY KEY (codigo_estante);


--
-- TOC entry 3278 (class 2606 OID 49278)
-- Name: estante_secao estante_secao_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.estante_secao
    ADD CONSTRAINT estante_secao_pkey PRIMARY KEY (codigo_estante, codigo_secao);


--
-- TOC entry 3280 (class 2606 OID 49280)
-- Name: exemplar exemplar_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exemplar
    ADD CONSTRAINT exemplar_pkey PRIMARY KEY (codigo_exemplar);


--
-- TOC entry 3282 (class 2606 OID 49282)
-- Name: livro livro_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.livro
    ADD CONSTRAINT livro_pkey PRIMARY KEY (isbn);


--
-- TOC entry 3285 (class 2606 OID 49284)
-- Name: multa multa_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.multa
    ADD CONSTRAINT multa_pkey PRIMARY KEY (codigo_multa);


--
-- TOC entry 3287 (class 2606 OID 49286)
-- Name: secao secao_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.secao
    ADD CONSTRAINT secao_pkey PRIMARY KEY (codigo_secao);


--
-- TOC entry 3290 (class 2606 OID 49288)
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (codigo_usuario);


--
-- TOC entry 3260 (class 1259 OID 49571)
-- Name: unq_cpf_bib; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unq_cpf_bib ON public.bibliotecario USING btree (cpf);


--
-- TOC entry 3288 (class 1259 OID 49570)
-- Name: unq_cpf_usu; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unq_cpf_usu ON public.usuario USING btree (cpf);


--
-- TOC entry 3283 (class 1259 OID 49572)
-- Name: unq_isbn; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unq_isbn ON public.livro USING btree (isbn);


--
-- TOC entry 3308 (class 2620 OID 49289)
-- Name: emprestimo tg_checkemprestimopendencia; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_checkemprestimopendencia AFTER INSERT ON public.emprestimo FOR EACH STATEMENT EXECUTE FUNCTION public.checkemprestimopendencia();


--
-- TOC entry 3307 (class 2620 OID 49290)
-- Name: categoria tg_deletecategoriasubordinada; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_deletecategoriasubordinada BEFORE DELETE ON public.categoria FOR EACH ROW EXECUTE FUNCTION public.deletecategoriasubordinada();


--
-- TOC entry 3310 (class 2620 OID 49291)
-- Name: livro tg_deletelivroexemplar; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_deletelivroexemplar BEFORE DELETE ON public.livro FOR EACH ROW EXECUTE FUNCTION public.deletelivroexemplar();


--
-- TOC entry 3309 (class 2620 OID 49292)
-- Name: exemplar tg_setnullexemplar; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_setnullexemplar BEFORE DELETE ON public.exemplar FOR EACH ROW EXECUTE FUNCTION public.setnullemprestimoexemplar();


--
-- TOC entry 3305 (class 2606 OID 49558)
-- Name: livro autor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.livro
    ADD CONSTRAINT autor_fkey FOREIGN KEY (codigo_autor) REFERENCES public.autor(codigo_autor) NOT VALID;


--
-- TOC entry 3294 (class 2606 OID 49293)
-- Name: emprestimo bibliotecario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.emprestimo
    ADD CONSTRAINT bibliotecario_fkey FOREIGN KEY (codigo_bibliotecario) REFERENCES public.bibliotecario(codigo_bibliotecario) NOT VALID;


--
-- TOC entry 3297 (class 2606 OID 49298)
-- Name: endereco_bibliotecario bibliotecario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.endereco_bibliotecario
    ADD CONSTRAINT bibliotecario_fkey FOREIGN KEY (codigo_bibliotecario) REFERENCES public.bibliotecario(codigo_bibliotecario) NOT VALID;


--
-- TOC entry 3303 (class 2606 OID 49303)
-- Name: livro categoria_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.livro
    ADD CONSTRAINT categoria_fkey FOREIGN KEY (codigo_categoria) REFERENCES public.categoria(codigo_categoria) NOT VALID;


--
-- TOC entry 3304 (class 2606 OID 49308)
-- Name: livro editora_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.livro
    ADD CONSTRAINT editora_fkey FOREIGN KEY (codigo_editora) REFERENCES public.editora(codigo_editora) NOT VALID;


--
-- TOC entry 3306 (class 2606 OID 49313)
-- Name: multa emprestimo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.multa
    ADD CONSTRAINT emprestimo_fkey FOREIGN KEY (codigo_emprestimo) REFERENCES public.emprestimo(codigo_emprestimo) NOT VALID;


--
-- TOC entry 3293 (class 2606 OID 49318)
-- Name: devolucao emprestimo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.devolucao
    ADD CONSTRAINT emprestimo_fkey FOREIGN KEY (codigo_emprestimo) REFERENCES public.emprestimo(codigo_emprestimo) NOT VALID;


--
-- TOC entry 3299 (class 2606 OID 49323)
-- Name: estante_secao estante_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.estante_secao
    ADD CONSTRAINT estante_fkey FOREIGN KEY (codigo_estante) REFERENCES public.estante(codigo_estante) NOT VALID;


--
-- TOC entry 3302 (class 2606 OID 49565)
-- Name: exemplar estante_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exemplar
    ADD CONSTRAINT estante_fkey FOREIGN KEY (codigo_estante) REFERENCES public.estante(codigo_estante) NOT VALID;


--
-- TOC entry 3295 (class 2606 OID 49328)
-- Name: emprestimo exemplar_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.emprestimo
    ADD CONSTRAINT exemplar_fkey FOREIGN KEY (codigo_exemplar) REFERENCES public.exemplar(codigo_exemplar) NOT VALID;


--
-- TOC entry 3301 (class 2606 OID 49333)
-- Name: exemplar livro_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exemplar
    ADD CONSTRAINT livro_fkey FOREIGN KEY (isbn) REFERENCES public.livro(isbn) NOT VALID;


--
-- TOC entry 3300 (class 2606 OID 49338)
-- Name: estante_secao secao_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.estante_secao
    ADD CONSTRAINT secao_fkey FOREIGN KEY (codigo_secao) REFERENCES public.secao(codigo_secao) NOT VALID;


--
-- TOC entry 3291 (class 2606 OID 49343)
-- Name: categoria_subordinada sub_categoria_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categoria_subordinada
    ADD CONSTRAINT sub_categoria_fkey FOREIGN KEY (codigo_sub_categoria) REFERENCES public.categoria(codigo_categoria) NOT VALID;


--
-- TOC entry 3292 (class 2606 OID 49348)
-- Name: categoria_subordinada super_categoria_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categoria_subordinada
    ADD CONSTRAINT super_categoria_fkey FOREIGN KEY (codigo_super_categoria) REFERENCES public.categoria(codigo_categoria) NOT VALID;


--
-- TOC entry 3296 (class 2606 OID 49353)
-- Name: emprestimo usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.emprestimo
    ADD CONSTRAINT usuario_fkey FOREIGN KEY (codigo_usuario) REFERENCES public.usuario(codigo_usuario) NOT VALID;


--
-- TOC entry 3298 (class 2606 OID 49358)
-- Name: endereco_usuario usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.endereco_usuario
    ADD CONSTRAINT usuario_fkey FOREIGN KEY (codigo_usuario) REFERENCES public.usuario(codigo_usuario) NOT VALID;


--
-- PostgreSQL database dump complete
--

