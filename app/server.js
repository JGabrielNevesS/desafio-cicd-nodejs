import express, { json } from 'express';

const port = process.env.PORT || 3000;
const host = '127.0.0.1';

const app = express();
 
const response = {
    message: 'Olá, mundo!',
}

app.get('/', (_req, res) => {
    res.json(response);
});

app.listen(port, () => {
    console.log(`Servidor rodando em http://${host}:${port}`);
}); 
