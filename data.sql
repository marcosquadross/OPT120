CREATE TABLE IF NOT EXISTS usuario (
	id INTEGER auto_increment,
	nome VARCHAR(200),
    email VARCHAR(200),
    senha VARCHAR(200),
    primary key (id)
);

CREATE TABLE IF NOT EXISTS atividade (
	id INTEGER auto_increment,
    titulo VARCHAR(200),
    descrição VARCHAR(200),
    data DATETIME,
    primary key (id)
);

CREATE TABLE IF NOT EXISTS usuario_atividade (
	usuario_id INTEGER,
    atividade_id INTEGER,
    entrega DATETIME,
    nota DOUBLE,
    primary key(usuario_id, atividade_id),
    foreign key(usuario_id) references usuario(id),
	foreign key(atividade_id) references atividade(id)
);

select * from usuario;