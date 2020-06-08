CREATE TABLE scheduled_emails
(
    id        VARCHAR(80)   NOT NULL,
    recipient TEXT          NOT NULL,
    subject   TEXT          NOT NULL,
    content   TEXT          NOT NULL
);
ALTER TABLE scheduled_emails
    ADD CONSTRAINT scheduled_emails_id PRIMARY KEY (id);