import express from 'express';

const port = process.env.PORT || 3000;
const host = '127.0.0.1';

const app = express();
app.disable('x-powered-by');

app.get('/', (_req, res) => {
    res.send('Hello World!');
});

app.listen(port, host, () => {
    console.log(`Servidor rodando em http://${host}:${port}`);
}); 
