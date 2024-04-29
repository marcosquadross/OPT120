const db = require('../configs/db');

class UserActivityController {

    createUserActivity(req, res) {
        const { user_id, activity_id, delivery_date, score } = req.body;
        db.query('INSERT INTO user_activity (user_id, activity_id, delivery_date, score) VALUES (?, ?, ?, ?)', [user_id, activity_id, delivery_date, score], (err, results, fields) => {
            if(err) {
                if(err = 'ER_DUP_ENTRY') {
                    res.status(409).json({ message: 'Atividade já atribuida para o usuário'});
                } else if (err) {
                    res.status(500).json({ message: 'Erro ao executar consulta SQL' });
                }
            } else {
                res.status(201).json({ message: 'Atividade atribuida com sucesso' });
            }
        });         
    }

    getUserActivity(req, res) {
        const { user_id, activity_id } = req.body;
        db.query('SELECT * FROM user_activity WHERE user_id = ? AND activity_id = ?', [user_id, activity_id], (err, results, fields) => {
            if (err) {
                console.error('Erro ao executar consulta SQL:', err);
                return;
            }
            res.status(200).json(results);
        });
    }

    listUserActivities(req, res) {
        db.query('SELECT * FROM user_activity', (err, results, fields) => {
            if (err) {
                console.error('Erro ao executar consulta SQL:', err);
                return;
            }
            res.status(200).json(results);
        });
    }

    listUserActivitiesByUser(req, res) {
        const { user_id } = req.params;
        db.query('SELECT * FROM user_activity WHERE user_id = ?', [user_id], (err, results, fields) => {
            if (err) {
                console.error('Erro ao executar consulta SQL:', err);
                return;
            }
            res.status(200).json(results);
        });
    }

    listUserActivitiesByActivity(req, res) {
        const { activity_id } = req.params;
        db.query('SELECT * FROM user_activity WHERE activity_id = ?', [activity_id], (err, results, fields) => {
            if (err) {
                console.error('Erro ao executar consulta SQL:', err);
                return;
            }
            res.status(200).json(results);
        });
    }

    updateScore(req, res) {
        const { user_id, activity_id, score } = req.body;
        db.query('UPDATE user_activity SET score = ? WHERE user_id = ? AND activity_id = ?', [score, user_id, activity_id], (err, results, fields) => {
            if(err) {
                res.status(500).json({ message: 'Erro ao executar consulta SQL' });
            } else {
                res.status(200).json({ message: 'Nota atualizada com sucesso' });
            }
        });
    }

    deleteUserActivity(req, res) {
        const { user_id, activity_id } = req.body;

        db.query('DELETE FROM user_activity WHERE user_id = ? AND activity_id = ?', [user_id, activity_id], (err, results, fields) => {
            if (err) {
                console.error('Erro ao executar consulta SQL:', err);
                return;
            }
            res.status(200).json(results);
        });
    }
}

module.exports = new UserActivityController();