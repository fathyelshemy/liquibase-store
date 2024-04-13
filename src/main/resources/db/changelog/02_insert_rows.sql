--liquibase formatted sql changeLogId:17b2a88a-53ba-4df8-8467-03aa5i8a3b36
--changeset fathyelshemy:1 context:prod



INSERT INTO public.product (id, product_name, production_date, expire_date, create_timestamp, created_by, modified_by,
                            modified_timestamp)
VALUES (1, 'credit card', 123232, 123232, DEFAULT, 'anonymous',
        'anonymous', DEFAULT);

INSERT INTO public.product (id, product_name, production_date, expire_date, create_timestamp, created_by, modified_by,
                            modified_timestamp)
VALUES (2, 'debit card', 212342343, 134123412343, DEFAULT,
        'anonymous', 'anonymous', DEFAULT);

--rollback delete from product  where product_name = 'debit card';
--rollback delete from product  where product_name = 'credit card';
