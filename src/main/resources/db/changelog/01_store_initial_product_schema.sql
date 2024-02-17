--liquibase formatted sql changeLogId:17b2a88a-53ba-4df8-8467-03a3be8a3a75
--changeset fathyelshemy:1 context:prod

create  table if not exists product(
        id bigint UNIQUE  NOT NULL,
        product_name character varying(255) COLLATE pg_catalog."default",
        production_date bigint NOT NULL,
        expire_date bigint NOT NULL,
        create_timestamp bigint NOT NULL default extract('epoch' from CURRENT_TIMESTAMP),
        created_by character varying(255) COLLATE pg_catalog."default",
        modified_by character varying(255) COLLATE pg_catalog."default",
        modified_timestamp bigint NOT NULL default extract('epoch' from CURRENT_TIMESTAMP),
        CONSTRAINT country_pkey PRIMARY KEY (id)
);

-- rollback Drop Table product;
