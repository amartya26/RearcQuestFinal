const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

// Access the environment variable
const SECRET_WORD = process.env.SECRET_WORD || 'Not Set';

app.get('/', (req, res) => {
  res.send(`SECRET_WORD is: ${SECRET_WORD}`);
});

app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
