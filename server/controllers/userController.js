const db = require('../configs/db');

class UserController {
    createUser(req, res) {
        const { name, email, password } = req.body;
        db.query('INSERT INTO user (name, email, password) VALUES (?, ?, ?)', [name, email, password], (err, results, fields) => {
            if (err) {
                console.error('Erro ao executar consulta SQL:', err);
                return;
            }
            res.status(201).json(results);
        });
    }

   listUsers(req, res) {
        db.query('SELECT * FROM user', (err, results, fields) => {
            if (err) {
                console.error('Erro ao executar consulta SQL:', err);
                return;
            }
            res.status(200).json(results);
        });
    }

    getUser(req, res) {
        const { id } = req.params;
        db.query('SELECT * FROM user WHERE id = ?', [id], (err, results, fields) => {
            if (err) {
                console.error('Erro ao executar consulta SQL:', err);
                return;
            }
            res.status(200).json(results[0]);   
        });
    }

    updateUser(req, res) {
        const { name, email, password } = req.body;
        const { id } = req.params;
        db.query('UPDATE user SET name = ?, email = ?, password = ? WHERE id = ?', [name, email, password, id], (err, results, fields) => {
            if (err) {
                console.error('Erro ao executar consulta SQL:', err);
                return;
            }
            res.status(200).json(results);
        });
    }

    deleteUser(req, res) {
        const { id } = req.params;
        db.query('DELETE FROM user WHERE id = ?', [id], (err, results, fields) => {
            if (err) {
                console.error('Erro ao executar consulta SQL:', err);
                return;
            }
            res.status(200).json(results);
        });
    }
}

module.exports = new UserController();
