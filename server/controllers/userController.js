const db = require('../configs/db');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const dotenv = require('dotenv');

dotenv.config();

class UserController {
    createUser(req, res) {
        const { name, email, password } = req.body;
        const hashedPassword = bcrypt.hashSync(password, bcrypt.genSaltSync(10));

        db.query('INSERT INTO user (name, email, password) VALUES (?, ?, ?)', [name, email, hashedPassword], (err, results, fields) => {
            if (err) {
                if (err.code === 'ER_DUP_ENTRY') {
                    res.status(409).json({ message: 'Email já cadastrado'});
                } else {
                    console.error('Erro ao executar consulta SQL:', err);
                    res.status(500).json({ message: 'Erro ao executar consulta SQL', err: err});
                }
            } else {
                res.status(201).json({ message: 'Usuário cadastrado com sucesso' });
            }
        });
    }

   listUsers(req, res) {
        db.query('SELECT * FROM user', (err, results, fields) => {
            if (err) {
                console.error('Erro ao executar consulta SQL:', err);
                res.status(500).json({ message: 'Erro ao executar consulta SQL', err: err});
            }
            // delete results[0].password;
            res.status(200).json(results);
        });
    }

    getUser(req, res) {
        const { id } = req.params;
        db.query('SELECT * FROM user WHERE id = ?', [id], (err, results, fields) => {
            if (err) {
                console.error('Erro ao executar consulta SQL:', err);
                res.status(500).json({ message: 'Erro ao executar consulta SQL', err: err});
            }
            // delete results[0].password;
            res.status(200).json(results[0]);   
        });
    }

    updateUser(req, res) {
        const { name, email, password } = req.body;
        const { id } = req.params;
        db.query('UPDATE user SET name = ?, email = ?, password = ? WHERE id = ?', [name, email, password, id], (err, results, fields) => {
            if (err) {
                if (err.code === 'ER_DUP_ENTRY') {
                    res.status(409).json({ message: 'Email já cadastrado'});
                } else {
                    res.status(500).json({ message: 'Erro ao executar consulta SQL' });
                }
            }
            res.status(200).json({ message: 'Usuário atualizado com sucesso' });
        });
    }

    deleteUser(req, res) {
        const { id } = req.params;
        db.query('DELETE FROM user WHERE id = ?', [id], (err, results, fields) => {
            if (err) {
                console.error('Erro ao executar consulta SQL:', err);
                res.status(500).json({ message: 'Erro ao executar consulta SQL', err: err});
            }
            res.status(200).json(results);
        });
    }

    login(req, res) {
        const { email, password } = req.body;
        db.query('SELECT * FROM user WHERE email = ?', [email], (err, results, fields) => {
            if (err) {
                console.error('Erro ao executar consulta SQL:', err);
                res.status(500).json({ message: 'Erro ao executar consulta SQL', err: err});
            }
            if (results.length === 0) {
                res.status(401).json({ message: 'Email ou senha inválido' });
            } else {
                const user = results[0];
                if (bcrypt.compareSync(password, user.password)) {
                    const accessToken = jwt.sign({ email: user.email, id: user.id }, process.env.SECRET_KEY, { expiresIn: '15m' });
                
                    const refreshToken = jwt.sign({ email: user.email, id: user.id }, process.env.SECRET_KEY, { expiresIn: '7d' });

                    res.status(200).json({ message: 'Usuário autenticado com sucesso', accessToken, refreshToken});
                } else {
                    res.status(401).json({ message: 'Email ou senha inválido' });
                }
            }
        });
    }
}

module.exports = new UserController();
