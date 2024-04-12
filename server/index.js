const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const app = express();
const port = 3000;

app.use(bodyParser.json());
app.use(cors());
app.use('/', require('./routes/index.js'));

app.listen(port, () => {
    console.log(`Server listening at http://localhost:${port}`);
});

