--liquibase formatted sql changeLogId:12c3a89a-345j-2kx9-8467-03aa5i8a7a84
--changeset fathyelshemy:1 context:prod


INSERT INTO public.product (id, product_name, production_date, expire_date, create_timestamp, created_by, modified_by,
                            modified_timestamp)
VALUES (3, 'personal loans', 123232, 123232, DEFAULT, 'anonymous',
        'anonymous', DEFAULT);

INSERT INTO public.product (id, product_name, production_date, expire_date, create_timestamp, created_by, modified_by,
                            modified_timestamp)
VALUES (4, 'mortgage', 212342343, 134123412343, DEFAULT,
        'anonymous', 'anonymous', DEFAULT);

--rollback delete from product  where product_name = 'personal loans';
--rollback delete from product  where product_name = 'mortgage';
