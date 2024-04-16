const db = require('../configs/db');

class UserActivityController {

    createUserActivity(req, res) {
        const { user_id, activity_id, delivery_date, score } = req.body;
        db.query('INSERT INTO user_activity (user_id, activity_id, delivery_date, score) VALUES (?, ?, ?, ?)', [user_id, activity_id, delivery_date, score], (err, results, fields) => {
            if (err) {
                console.error('Erro ao executar consulta SQL:', err);
                return;
            }
            res.status(201).json(results);
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

    updateUserActivity(req, res) {
        const { user_id, activity_id, delivery_date, score } = req.body;
        const { id } = req.params;
        db.query('UPDATE user_activity SET user_id = ?, activity_id = ?, delivery_date = ?, score = ? WHERE id = ?', [user_id, activity_id, delivery_date, score, id], (err, results, fields) => {
            if (err) {
                console.error('Erro ao executar consulta SQL:', err);
                return;
            }
            res.status(200).json(results);  
        });
    }

    deleteUserActivity(req, res) {
        const { id } = req.params;

        db.query('DELETE FROM user_activity WHERE id = ?', [id], (err, results, fields) => {
            if (err) {
                console.error('Erro ao executar consulta SQL:', err);
                return;
            }
            res.status(200).json(results);
        });
    }
}

module.exports = new UserActivityController();