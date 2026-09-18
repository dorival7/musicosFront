const fonts = [
  { id: "bebas-neue", nome: "Bebas Neue", family: "Bebas Neue", categoria: "Impacto" },
  { id: "oswald", nome: "Oswald", family: "Oswald", categoria: "Condensada" },
  { id: "pacifico", nome: "Pacifico", family: "Pacifico", categoria: "Manuscrita" },
  { id: "permanent-marker", nome: "Permanent Marker", family: "Permanent Marker", categoria: "Brush" },
  { id: "bangers", nome: "Bangers", family: "Bangers", categoria: "Display" },
  { id: "righteous", nome: "Righteous", family: "Righteous", categoria: "Display" },
  { id: "black-ops-one", nome: "Black Ops One", family: "Black Ops One", categoria: "Impacto" },
  { id: "rock-salt", nome: "Rock Salt", family: "Rock Salt", categoria: "Brush" }
];

export function obterFontePorId(id) {
  return fonts.find(fonte => fonte.id === id) || fonts[0];
}

export default fonts;
