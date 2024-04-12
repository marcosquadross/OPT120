CREATE TABLE IF NOT EXISTS user (
	id INTEGER auto_increment,
	name VARCHAR(200),
    email VARCHAR(200),
    password VARCHAR(200),
    primary key (id)
);

CREATE TABLE IF NOT EXISTS activity (
	id INTEGER auto_increment,
    title VARCHAR(200),
    description VARCHAR(200),
    date DATETIME,
    primary key (id)
);

CREATE TABLE IF NOT EXISTS user_activity (
	user_id INTEGER,
    activity_id INTEGER,
    delivery_date DATETIME,
    score DOUBLE,
    primary key(user_id, activity_id),
    foreign key(user_id) references user(id),
	foreign key(activity_id) references activity(id)
);

select * from user;
select * from activity;
select * from user_activity;
