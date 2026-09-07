import express from 'express';

const port = process.env.PORT || 3000;
const host = '127.0.0.1';

const app = express();
 
const response = {
    message: 'Olá, mundo!',
}

app.get('/', (_req, res) => {
    res.send(response);
});

app.listen(host ,port, () => {
    console.log(`Servidor rodando em http://${host}:${port}`);
}); 
