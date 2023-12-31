PGDMP     0                
    {            Banco III 2023/2    13.2    13.2 L    *           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            +           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            ,           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            -           1262    40970    Banco III 2023/2    DATABASE     r   CREATE DATABASE "Banco III 2023/2" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Portuguese_Brazil.1252';
 "   DROP DATABASE "Banco III 2023/2";
                postgres    false            �            1255    41143    loops(text)    FUNCTION     R  CREATE FUNCTION public.loops(tipo_loop text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
loops int DEFAULT 0;
BEGIN
IF tipo_loop = 'while' THEN
/* Loop com WHILE */
WHILE loops < 10 LOOP
loops := loops + 1;
RAISE NOTICE 'Número de loops de WHILE: %', loops;
END LOOP;
ELSEIF tipo_loop = 'loop' THEN
/* Loop com LOOP */
LOOP
loops := loops + 1;
RAISE NOTICE 'Número de loops de LOOP: %', loops;
EXIT WHEN loops > 14;
END LOOP;
ELSEIF tipo_loop = 'for' THEN
/* Loop com FOR */
FOR loops IN 1..20 LOOP
RAISE NOTICE 'Número de loops de FOR: %', loops;
END LOOP;
END IF;
RETURN;
END;
$$;
 ,   DROP FUNCTION public.loops(tipo_loop text);
       public          postgres    false            �            1255    42330    obter_ultima_compra(integer)    FUNCTION     O  CREATE FUNCTION public.obter_ultima_compra(fornecedores_codigo integer) RETURNS timestamp without time zone
    LANGUAGE plpgsql
    AS $$
DECLARE
    ultima_compra timestamp;
BEGIN
    SELECT MAX(data_compra) INTO ultima_compra
    FROM compras
    WHERE codigo_fornecedores = fornecedores_codigo;

    RETURN ultima_compra;
END;
$$;
 G   DROP FUNCTION public.obter_ultima_compra(fornecedores_codigo integer);
       public          postgres    false            �            1255    42327    testerowtype(numeric)    FUNCTION     F  CREATE FUNCTION public.testerowtype(n numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
ret boolean;
varlin itens%ROWTYPE;
BEGIN
ret:=false;
SELECT * INTO varlin FROM itens WHERE codigo=n;
IF FOUND THEN
INSERT INTO logitens(id,status) VALUES (varlin.codigo,'Encontrado');
ret:=true;
END IF;
RETURN ret;
END;
$$;
 .   DROP FUNCTION public.testerowtype(n numeric);
       public          postgres    false            �            1255    42328    verificar_estoque(integer)    FUNCTION     9  CREATE FUNCTION public.verificar_estoque(item_codigo integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    DECLARE
        estoque_atual integer;
    BEGIN
        SELECT estoque INTO estoque_atual
        FROM itens
        WHERE codigo = itens_codigo;

        
        IF estoque_atual > 150 THEN
            RAISE NOTICE 'O item de código % possui estoque superior a 150 unidades.', itens_codigo;
        ELSE
            RAISE NOTICE 'O item de código % possui estoque igual ou inferior a 150 unidades.', itens_codigo;
        END IF;
    END;
END;
$$;
 =   DROP FUNCTION public.verificar_estoque(item_codigo integer);
       public          postgres    false            �            1259    40971    clientes    TABLE     �  CREATE TABLE public.clientes (
    codcliente integer NOT NULL,
    nome character varying(50) NOT NULL,
    endereco character varying(50) NOT NULL,
    tipo_cliente character(1),
    rg character(15),
    cpf character(15),
    cnpj character(14),
    obs text,
    CONSTRAINT clientes_codcliente_check CHECK ((codcliente > 0)),
    CONSTRAINT clientes_tipo_cliente_check CHECK (((tipo_cliente = 'F'::bpchar) OR (tipo_cliente = 'J'::bpchar)))
);
    DROP TABLE public.clientes;
       public         heap    postgres    false            �            1259    41094    compras    TABLE     �   CREATE TABLE public.compras (
    codigo integer NOT NULL,
    codfornecedor integer NOT NULL,
    data date,
    valor_total numeric(10,2),
    numero_nota integer NOT NULL
);
    DROP TABLE public.compras;
       public         heap    postgres    false            �            1259    41106    compras_itens    TABLE     �   CREATE TABLE public.compras_itens (
    sequencial integer NOT NULL,
    codcompra integer NOT NULL,
    coditem integer NOT NULL,
    desconto numeric(4,2),
    quantidade integer,
    valor numeric(10,2),
    valor_total numeric(10,2)
);
 !   DROP TABLE public.compras_itens;
       public         heap    postgres    false            �            1259    41104    compras_itens_sequencial_seq    SEQUENCE     �   CREATE SEQUENCE public.compras_itens_sequencial_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.compras_itens_sequencial_seq;
       public          postgres    false    213            .           0    0    compras_itens_sequencial_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public.compras_itens_sequencial_seq OWNED BY public.compras_itens.sequencial;
          public          postgres    false    212            �            1259    41122    contas_pagar    TABLE     �  CREATE TABLE public.contas_pagar (
    numero integer NOT NULL,
    num_boleto character varying(30),
    tipo integer NOT NULL,
    data_vencimento date,
    data_pagamento date,
    valor_pago numeric(10,2),
    valor numeric(10,2),
    data_lancamento date,
    desconto numeric(10,2),
    compra integer,
    despesas integer,
    CONSTRAINT contas_pagar_tipo_check CHECK (((tipo = 1) OR (tipo = 2)))
);
     DROP TABLE public.contas_pagar;
       public         heap    postgres    false            �            1259    41035    contas_receber    TABLE     	  CREATE TABLE public.contas_receber (
    cod integer NOT NULL,
    data_lancamento date NOT NULL,
    data_vencimento date NOT NULL,
    valor numeric(10,2) NOT NULL,
    data_pagamento date,
    valor_pagamento numeric(10,2),
    codigo_vendas integer NOT NULL
);
 "   DROP TABLE public.contas_receber;
       public         heap    postgres    false            �            1259    41133    despesas    TABLE     c   CREATE TABLE public.despesas (
    codigo integer NOT NULL,
    descricao character varying(50)
);
    DROP TABLE public.despesas;
       public         heap    postgres    false            �            1259    40981    fones_clientes    TABLE     n   CREATE TABLE public.fones_clientes (
    cliente integer NOT NULL,
    num_telefone character(10) NOT NULL
);
 "   DROP TABLE public.fones_clientes;
       public         heap    postgres    false            �            1259    41087    fornecedores    TABLE     �   CREATE TABLE public.fornecedores (
    codigo integer NOT NULL,
    descricao character varying(100),
    endereco character varying(50),
    contato character varying(50),
    cnpj character varying(14)
);
     DROP TABLE public.fornecedores;
       public         heap    postgres    false            �            1259    40991    funcionarios    TABLE     G  CREATE TABLE public.funcionarios (
    codfunc integer NOT NULL,
    nome character varying(50) NOT NULL,
    endereco character varying(50) NOT NULL,
    cpf character(11) NOT NULL,
    tipo character(1),
    CONSTRAINT funcionarios_tipo_check CHECK (((tipo = '1'::bpchar) OR (tipo = '2'::bpchar) OR (tipo = '3'::bpchar)))
);
     DROP TABLE public.funcionarios;
       public         heap    postgres    false            �            1259    41045    itens    TABLE     /  CREATE TABLE public.itens (
    codigo integer NOT NULL,
    valor numeric(10,2) NOT NULL,
    custo numeric(10,2) NOT NULL,
    descricao text,
    desconto numeric(4,2),
    tipo character(1),
    estoque real,
    CONSTRAINT itens_tipo_check CHECK (((tipo = 'p'::bpchar) OR (tipo = 's'::bpchar)))
);
    DROP TABLE public.itens;
       public         heap    postgres    false            �            1259    41071    ordens_itens    TABLE     �   CREATE TABLE public.ordens_itens (
    sequencial integer NOT NULL,
    numero integer NOT NULL,
    codigo integer NOT NULL,
    desconto numeric(4,2),
    quantidade real,
    valor numeric(10,2),
    valor_total numeric(10,2)
);
     DROP TABLE public.ordens_itens;
       public         heap    postgres    false            �            1259    41069    ordens_itens_sequencial_seq    SEQUENCE     �   CREATE SEQUENCE public.ordens_itens_sequencial_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.ordens_itens_sequencial_seq;
       public          postgres    false    209            /           0    0    ordens_itens_sequencial_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.ordens_itens_sequencial_seq OWNED BY public.ordens_itens.sequencial;
          public          postgres    false    208            �            1259    40999    ordens_servico    TABLE     1  CREATE TABLE public.ordens_servico (
    numero integer NOT NULL,
    data date,
    valor_total numeric(10,2),
    status character(1),
    codfunc integer NOT NULL,
    codcliente integer NOT NULL,
    CONSTRAINT ordens_servico_status_check CHECK (((status = 'a'::bpchar) OR (status = 'f'::bpchar)))
);
 "   DROP TABLE public.ordens_servico;
       public         heap    postgres    false            �            1259    41054    venda_itens    TABLE     �   CREATE TABLE public.venda_itens (
    sequencial integer NOT NULL,
    codvenda integer NOT NULL,
    codigo integer,
    quantidade real,
    valor numeric(10,2)
);
    DROP TABLE public.venda_itens;
       public         heap    postgres    false            �            1259    41015    vendas    TABLE     �   CREATE TABLE public.vendas (
    codigo integer NOT NULL,
    valor_total_venda numeric(10,2),
    dt_venda date NOT NULL,
    codfunc integer NOT NULL,
    codcliente integer NOT NULL,
    numero integer
);
    DROP TABLE public.vendas;
       public         heap    postgres    false            d           2604    41109    compras_itens sequencial    DEFAULT     �   ALTER TABLE ONLY public.compras_itens ALTER COLUMN sequencial SET DEFAULT nextval('public.compras_itens_sequencial_seq'::regclass);
 G   ALTER TABLE public.compras_itens ALTER COLUMN sequencial DROP DEFAULT;
       public          postgres    false    212    213    213            c           2604    41074    ordens_itens sequencial    DEFAULT     �   ALTER TABLE ONLY public.ordens_itens ALTER COLUMN sequencial SET DEFAULT nextval('public.ordens_itens_sequencial_seq'::regclass);
 F   ALTER TABLE public.ordens_itens ALTER COLUMN sequencial DROP DEFAULT;
       public          postgres    false    208    209    209                      0    40971    clientes 
   TABLE DATA           `   COPY public.clientes (codcliente, nome, endereco, tipo_cliente, rg, cpf, cnpj, obs) FROM stdin;
    public          postgres    false    200   /i       #          0    41094    compras 
   TABLE DATA           X   COPY public.compras (codigo, codfornecedor, data, valor_total, numero_nota) FROM stdin;
    public          postgres    false    211   Lj       %          0    41106    compras_itens 
   TABLE DATA           q   COPY public.compras_itens (sequencial, codcompra, coditem, desconto, quantidade, valor, valor_total) FROM stdin;
    public          postgres    false    213   �j       &          0    41122    contas_pagar 
   TABLE DATA           �   COPY public.contas_pagar (numero, num_boleto, tipo, data_vencimento, data_pagamento, valor_pago, valor, data_lancamento, desconto, compra, despesas) FROM stdin;
    public          postgres    false    214   fk                 0    41035    contas_receber 
   TABLE DATA           �   COPY public.contas_receber (cod, data_lancamento, data_vencimento, valor, data_pagamento, valor_pagamento, codigo_vendas) FROM stdin;
    public          postgres    false    205   8l       '          0    41133    despesas 
   TABLE DATA           5   COPY public.despesas (codigo, descricao) FROM stdin;
    public          postgres    false    215   �l                 0    40981    fones_clientes 
   TABLE DATA           ?   COPY public.fones_clientes (cliente, num_telefone) FROM stdin;
    public          postgres    false    201   `m       "          0    41087    fornecedores 
   TABLE DATA           R   COPY public.fornecedores (codigo, descricao, endereco, contato, cnpj) FROM stdin;
    public          postgres    false    210   �m                 0    40991    funcionarios 
   TABLE DATA           J   COPY public.funcionarios (codfunc, nome, endereco, cpf, tipo) FROM stdin;
    public          postgres    false    202   �n                 0    41045    itens 
   TABLE DATA           Y   COPY public.itens (codigo, valor, custo, descricao, desconto, tipo, estoque) FROM stdin;
    public          postgres    false    206   p       !          0    41071    ordens_itens 
   TABLE DATA           l   COPY public.ordens_itens (sequencial, numero, codigo, desconto, quantidade, valor, valor_total) FROM stdin;
    public          postgres    false    209    q                 0    40999    ordens_servico 
   TABLE DATA           `   COPY public.ordens_servico (numero, data, valor_total, status, codfunc, codcliente) FROM stdin;
    public          postgres    false    203   �q                 0    41054    venda_itens 
   TABLE DATA           V   COPY public.venda_itens (sequencial, codvenda, codigo, quantidade, valor) FROM stdin;
    public          postgres    false    207   r                 0    41015    vendas 
   TABLE DATA           b   COPY public.vendas (codigo, valor_total_venda, dt_venda, codfunc, codcliente, numero) FROM stdin;
    public          postgres    false    204   ~r       0           0    0    compras_itens_sequencial_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.compras_itens_sequencial_seq', 1, false);
          public          postgres    false    212            1           0    0    ordens_itens_sequencial_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.ordens_itens_sequencial_seq', 1, false);
          public          postgres    false    208            g           2606    40980    clientes clientes_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (codcliente);
 @   ALTER TABLE ONLY public.clientes DROP CONSTRAINT clientes_pkey;
       public            postgres    false    200            �           2606    41111     compras_itens compras_itens_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.compras_itens
    ADD CONSTRAINT compras_itens_pkey PRIMARY KEY (sequencial);
 J   ALTER TABLE ONLY public.compras_itens DROP CONSTRAINT compras_itens_pkey;
       public            postgres    false    213                       2606    41098    compras compras_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.compras
    ADD CONSTRAINT compras_pkey PRIMARY KEY (codigo);
 >   ALTER TABLE ONLY public.compras DROP CONSTRAINT compras_pkey;
       public            postgres    false    211            �           2606    41127    contas_pagar contas_pagar_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.contas_pagar
    ADD CONSTRAINT contas_pagar_pkey PRIMARY KEY (numero);
 H   ALTER TABLE ONLY public.contas_pagar DROP CONSTRAINT contas_pagar_pkey;
       public            postgres    false    214            s           2606    41039 "   contas_receber contas_receber_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.contas_receber
    ADD CONSTRAINT contas_receber_pkey PRIMARY KEY (cod);
 L   ALTER TABLE ONLY public.contas_receber DROP CONSTRAINT contas_receber_pkey;
       public            postgres    false    205            �           2606    41137    despesas despesas_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.despesas
    ADD CONSTRAINT despesas_pkey PRIMARY KEY (codigo);
 @   ALTER TABLE ONLY public.despesas DROP CONSTRAINT despesas_pkey;
       public            postgres    false    215            i           2606    40985 "   fones_clientes fones_clientes_pkey 
   CONSTRAINT     s   ALTER TABLE ONLY public.fones_clientes
    ADD CONSTRAINT fones_clientes_pkey PRIMARY KEY (cliente, num_telefone);
 L   ALTER TABLE ONLY public.fones_clientes DROP CONSTRAINT fones_clientes_pkey;
       public            postgres    false    201    201            {           2606    41093 "   fornecedores fornecedores_cnpj_key 
   CONSTRAINT     ]   ALTER TABLE ONLY public.fornecedores
    ADD CONSTRAINT fornecedores_cnpj_key UNIQUE (cnpj);
 L   ALTER TABLE ONLY public.fornecedores DROP CONSTRAINT fornecedores_cnpj_key;
       public            postgres    false    210            }           2606    41091    fornecedores fornecedores_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.fornecedores
    ADD CONSTRAINT fornecedores_pkey PRIMARY KEY (codigo);
 H   ALTER TABLE ONLY public.fornecedores DROP CONSTRAINT fornecedores_pkey;
       public            postgres    false    210            k           2606    40998 !   funcionarios funcionarios_cpf_key 
   CONSTRAINT     [   ALTER TABLE ONLY public.funcionarios
    ADD CONSTRAINT funcionarios_cpf_key UNIQUE (cpf);
 K   ALTER TABLE ONLY public.funcionarios DROP CONSTRAINT funcionarios_cpf_key;
       public            postgres    false    202            m           2606    40996    funcionarios funcionarios_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.funcionarios
    ADD CONSTRAINT funcionarios_pkey PRIMARY KEY (codfunc);
 H   ALTER TABLE ONLY public.funcionarios DROP CONSTRAINT funcionarios_pkey;
       public            postgres    false    202            u           2606    41053    itens itens_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.itens
    ADD CONSTRAINT itens_pkey PRIMARY KEY (codigo);
 :   ALTER TABLE ONLY public.itens DROP CONSTRAINT itens_pkey;
       public            postgres    false    206            y           2606    41076    ordens_itens ordens_itens_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.ordens_itens
    ADD CONSTRAINT ordens_itens_pkey PRIMARY KEY (sequencial);
 H   ALTER TABLE ONLY public.ordens_itens DROP CONSTRAINT ordens_itens_pkey;
       public            postgres    false    209            o           2606    41004 "   ordens_servico ordens_servico_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.ordens_servico
    ADD CONSTRAINT ordens_servico_pkey PRIMARY KEY (numero);
 L   ALTER TABLE ONLY public.ordens_servico DROP CONSTRAINT ordens_servico_pkey;
       public            postgres    false    203            w           2606    41058    venda_itens venda_itens_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.venda_itens
    ADD CONSTRAINT venda_itens_pkey PRIMARY KEY (sequencial, codvenda);
 F   ALTER TABLE ONLY public.venda_itens DROP CONSTRAINT venda_itens_pkey;
       public            postgres    false    207    207            q           2606    41019    vendas vendas_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT vendas_pkey PRIMARY KEY (codigo);
 <   ALTER TABLE ONLY public.vendas DROP CONSTRAINT vendas_pkey;
       public            postgres    false    204            �           2606    41099 "   compras compras_codfornecedor_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.compras
    ADD CONSTRAINT compras_codfornecedor_fkey FOREIGN KEY (codfornecedor) REFERENCES public.fornecedores(codigo);
 L   ALTER TABLE ONLY public.compras DROP CONSTRAINT compras_codfornecedor_fkey;
       public          postgres    false    2941    210    211            �           2606    41112 *   compras_itens compras_itens_codcompra_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.compras_itens
    ADD CONSTRAINT compras_itens_codcompra_fkey FOREIGN KEY (codcompra) REFERENCES public.compras(codigo);
 T   ALTER TABLE ONLY public.compras_itens DROP CONSTRAINT compras_itens_codcompra_fkey;
       public          postgres    false    2943    213    211            �           2606    41117 (   compras_itens compras_itens_coditem_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.compras_itens
    ADD CONSTRAINT compras_itens_coditem_fkey FOREIGN KEY (coditem) REFERENCES public.itens(codigo);
 R   ALTER TABLE ONLY public.compras_itens DROP CONSTRAINT compras_itens_coditem_fkey;
       public          postgres    false    206    213    2933            �           2606    41128 %   contas_pagar contas_pagar_compra_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.contas_pagar
    ADD CONSTRAINT contas_pagar_compra_fkey FOREIGN KEY (compra) REFERENCES public.compras(codigo);
 O   ALTER TABLE ONLY public.contas_pagar DROP CONSTRAINT contas_pagar_compra_fkey;
       public          postgres    false    2943    211    214            �           2606    41040 0   contas_receber contas_receber_codigo_vendas_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.contas_receber
    ADD CONSTRAINT contas_receber_codigo_vendas_fkey FOREIGN KEY (codigo_vendas) REFERENCES public.vendas(codigo);
 Z   ALTER TABLE ONLY public.contas_receber DROP CONSTRAINT contas_receber_codigo_vendas_fkey;
       public          postgres    false    205    204    2929            �           2606    41138    contas_pagar despesas_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.contas_pagar
    ADD CONSTRAINT despesas_fkey FOREIGN KEY (despesas) REFERENCES public.despesas(codigo);
 D   ALTER TABLE ONLY public.contas_pagar DROP CONSTRAINT despesas_fkey;
       public          postgres    false    2949    215    214            �           2606    40986 *   fones_clientes fones_clientes_cliente_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.fones_clientes
    ADD CONSTRAINT fones_clientes_cliente_fkey FOREIGN KEY (cliente) REFERENCES public.clientes(codcliente);
 T   ALTER TABLE ONLY public.fones_clientes DROP CONSTRAINT fones_clientes_cliente_fkey;
       public          postgres    false    200    2919    201            �           2606    41082 %   ordens_itens ordens_itens_codigo_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.ordens_itens
    ADD CONSTRAINT ordens_itens_codigo_fkey FOREIGN KEY (codigo) REFERENCES public.itens(codigo);
 O   ALTER TABLE ONLY public.ordens_itens DROP CONSTRAINT ordens_itens_codigo_fkey;
       public          postgres    false    2933    206    209            �           2606    41077 %   ordens_itens ordens_itens_numero_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.ordens_itens
    ADD CONSTRAINT ordens_itens_numero_fkey FOREIGN KEY (numero) REFERENCES public.ordens_servico(numero);
 O   ALTER TABLE ONLY public.ordens_itens DROP CONSTRAINT ordens_itens_numero_fkey;
       public          postgres    false    2927    203    209            �           2606    41010 -   ordens_servico ordens_servico_codcliente_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.ordens_servico
    ADD CONSTRAINT ordens_servico_codcliente_fkey FOREIGN KEY (codcliente) REFERENCES public.clientes(codcliente);
 W   ALTER TABLE ONLY public.ordens_servico DROP CONSTRAINT ordens_servico_codcliente_fkey;
       public          postgres    false    200    203    2919            �           2606    41005 *   ordens_servico ordens_servico_codfunc_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.ordens_servico
    ADD CONSTRAINT ordens_servico_codfunc_fkey FOREIGN KEY (codfunc) REFERENCES public.funcionarios(codfunc);
 T   ALTER TABLE ONLY public.ordens_servico DROP CONSTRAINT ordens_servico_codfunc_fkey;
       public          postgres    false    203    2925    202            �           2606    41064 #   venda_itens venda_itens_codigo_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.venda_itens
    ADD CONSTRAINT venda_itens_codigo_fkey FOREIGN KEY (codigo) REFERENCES public.itens(codigo);
 M   ALTER TABLE ONLY public.venda_itens DROP CONSTRAINT venda_itens_codigo_fkey;
       public          postgres    false    2933    207    206            �           2606    41059 %   venda_itens venda_itens_codvenda_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.venda_itens
    ADD CONSTRAINT venda_itens_codvenda_fkey FOREIGN KEY (codvenda) REFERENCES public.vendas(codigo);
 O   ALTER TABLE ONLY public.venda_itens DROP CONSTRAINT venda_itens_codvenda_fkey;
       public          postgres    false    2929    207    204            �           2606    41025    vendas vendas_codcliente_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT vendas_codcliente_fkey FOREIGN KEY (codcliente) REFERENCES public.clientes(codcliente);
 G   ALTER TABLE ONLY public.vendas DROP CONSTRAINT vendas_codcliente_fkey;
       public          postgres    false    204    2919    200            �           2606    41020    vendas vendas_codfunc_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT vendas_codfunc_fkey FOREIGN KEY (codfunc) REFERENCES public.funcionarios(codfunc);
 D   ALTER TABLE ONLY public.vendas DROP CONSTRAINT vendas_codfunc_fkey;
       public          postgres    false    202    204    2925            �           2606    41030    vendas vendas_numero_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT vendas_numero_fkey FOREIGN KEY (numero) REFERENCES public.ordens_servico(numero);
 C   ALTER TABLE ONLY public.vendas DROP CONSTRAINT vendas_numero_fkey;
       public          postgres    false    203    2927    204                 x����J�0��ӧ�'X����u��B��⩗Y�C �@RK��g�/fu��BȐ��g��BBIN�k�+���(�)����!�"����5���8ƢX��K������6�g�}*6�
��?c�vz��v�iǠ\æ�'j�x��re�#��~zw����9��E�!Kέ�%gC���<Px�+CX�fF|/{,9la���5z^Q�=��P�d�*X�?�
�9�/S��v�[���:5���.��M�?l�_}�U�$��h      #   �   x�5��D!�3��$��l�u,����7��L nH5*\hfo�9�� �`mP<�5}4��p��ϻb+�C���)�g�ߍ���)�gC��(DJ\�t��?&��b��q ��_�ӣcr�EI^�9��-2����}���.�      %   k   x�e��� D��L1��&RA��c�s�}��e�Ьc�1�fv���zbGV9��8>���\�����)l�D�*���;ga�!t��z�u_�ġ����� �d�'6      &   �   x�U��D!D�؋@mb+��ױ�EWOLBx� �@�H�Q2�)?�����B/��U�a93�RL&#�jQ���r���Kj���G�%|�3*������r����h�M�:C������r2ޘ/�QIA{�}��YOi1krg!�r��v����l�<��Nʤ��Ԡ�H����m�q:�p������R�A`�         �   x�e���0C��]舏,�	���Q[�Q�ɇ02椬L\H̥qf�B��[��e��-��!�L�0�mY�h�Nˀ�e�$F�1Rƀe����և!���*��>I�')�'YV�f��%;��6;�g��f��\e�d�=�W���VH      '   p   x�5˽�@����L)�&�Y:��wn؆*d�[,��}��gj���Xq�1r����j7Z܆�V�A���"+�N3Wq�W)�km���UI2Z<��/*2�s�0�' ?zo(�         B   x�=���0�w��Dp��%��a�"�9�����Z=���a��Ur��C�sj�'�X�]�{��]�      "   8  x�e�=n1F��)|��z��Oɏ�@A��H�dGb#X/DQ.����b�5D�����{�Y���S�,gm�y:�79��4",x�'�u]����{9��zyK0y��H�R<���:���EKtB�O�9���ҵ)r���]��S��m�q)�DG#,R��k���&V��_Qn��a��/��NkW��V+��H[#�y�SK��x摞ŏ6����0���B���4��q��������C!鲕1��&6�~�ۼ��_w8�Ԥ[.!9��ȅ��Z�2��_�mP�X��䋆�s%��'�|�           x�e�MN�@�s
���x~�.i�"U!�b�6��b��>����p�J,ؿ���v�_�aܧv�)3<p������H�M�]��4n*�I�1���vb%]z�~�@U�:��q��M�cb�������p7.ps�H|�����vθ��s��>��$���6�1ue����2�w�Ω�>������&�ǥ=	X���@����ˆx�q�� =�������|p��g$��J>�!�Y��w�t[���Vī�(��Z+j           x�M�Mn� F��\ `p|����:�)��6� �P�]��n�XWrW��=�0�ؑ1ҫv@�^Op�T>SX`ʏ�Ӟ�_I ���!E%��]X��驱tEB�7z��N�B�jol���'=5�c��m�A����,�`��'{U�
E|�P�0�`i�+��]{"���VRnki�D�_�t�Z��(�L�G��f'����Cٓ����'.ۼ���A���}��!�θK�a<�$\�Jj+�s��mDO!��i����u�/C�k�      !   d   x�]���0߻�D��G�Hp����V �h؏a�r�r@WMs��2%hiT(��J�`�Bw�!=�!����;���ѹ��H|�����!y         x   x�]�11k�7B��4i��'�<�MJ���AҜ� @�%�.W.�0OanܧY��c����Jm+�Ɛ��{ᦹpX�9.�*�}�=�K�M���O�q�3z��!%���r��P�*5         R   x�-���@�w(�	�C���C��ı��I^��X��`A�D|�uc���$�ԛ�g��J� ��ю���s��r�A         z   x�]��1C��.9��t��?G����JH<a0&V���ݛg#�:A�Ň�jᔬ�E��L�.�86�k6���}`X���6����6�Yц0����:��M^ׁe�3Z���wl{_f�%�(�     