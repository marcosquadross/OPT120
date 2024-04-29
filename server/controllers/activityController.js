const db = require('../configs/db');

class ActivityController {
    createActivity(req, res) {
        const { title, description, date } = req.body;
        db.query('INSERT INTO activity (title, description, date) VALUES (?, ?, ?)', [title, description, date], (err, results, fields) => {
            if (err) {
                res.status(500).json({ message: 'Erro ao executar consulta SQL', err });
            }
            res.status(201).json({ message: 'Atividade cadastrada com sucesso' , id: results.insertId});
        });
    }

    listActivities(req, res) {
        db.query('SELECT * FROM activity', (err, results, fields) => {
            if (err) {
                console.error('Erro ao executar consulta SQL:', err);
                res.status(500).json({ message: 'Erro ao executar consulta SQL' });
            }
            res.status(200).json(results);
        });
    }

    getActivity(req, res) {
        const { id } = req.params;
        db.query('SELECT * FROM activity WHERE id = ?', [id], (err, results, fields) => {
            if (err) {
                console.error('Erro ao executar consulta SQL:', err);
                res.status(500).json({ message: 'Erro ao executar consulta SQL' });
            }
            res.status(200).json(results[0]);                   
        });
    }

    updateActivity(req, res) {
        const { title, description, date } = req.body;
        const { id } = req.params;
        db.query('UPDATE activity SET title = ?, description = ?, date = ? WHERE id = ?', [title, description, date, id], (err, results, fields) => {
            if (err) {
                console.error('Erro ao executar consulta SQL:', err);
                res.status(500).json({ message: 'Erro ao executar consulta SQL', err });
            }
            res.status(200).json(results);
        });
    }

    deleteActivity(req, res) {
        const { id } = req.params;
        db.query('DELETE FROM activity WHERE id = ?', [id], (err, results, fields) => {
            if (err) {
                console.error('Erro ao executar consulta SQL:', err);
                res.status(500).json({ message: 'Erro ao executar consulta SQL' });
            }
            res.status(200).json({ message: 'Atividade deletada com sucesso', });
        });
    }
}

module.exports = new ActivityController();
