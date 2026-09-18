import showLuzes01 from "./show-luzes-01.png";

const backgrounds = [
  {
    id: "classic-gradient",
    nome: "Clássico",
    categoria: "padrao",
    tipo: "procedural",
    src: null,
    recomendadoPara: ["sertanejo-sunset"]
  },
  {
    id: "show-luzes-01",
    nome: "Show Luzes",
    categoria: "show",
    tipo: "imagem",
    src: showLuzes01,
    recomendadoPara: ["sertanejo-sunset"]
  }
];

export function obterBackgroundPorId(id) {
  return backgrounds.find(background => background.id === id) || backgrounds[0];
}

export function obterBackgroundsDoTemplate(templateId) {
  return backgrounds.filter(background =>
    !background.recomendadoPara ||
    background.recomendadoPara.length === 0 ||
    background.recomendadoPara.includes(templateId)
  );
}

export default backgrounds;
