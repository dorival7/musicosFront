import bkg1 from "./bkg1.jpg";
import bkg2 from "./bkg2.jpg";
import bkg3 from "./bkg3.jpg";
import bkg4 from "./bkg4.jpg";
import bkg5 from "./bkg5.jpg";
import bkg6 from "./bkg6.jpg";
import bkg7 from "./bkg7.jpg";
import bkg8 from "./bkg8.jpg";
import bkg9 from "./bkg9.jpg";
import bkg10 from "./bkg10.jpg";
import bkg11 from "./bkg11.jpg";
import bkg12 from "./bkg12.jpg";
import bkg13 from "./bkg13.jpg";
import bkg14 from "./bkg14.jpg";
import bkg15 from "./bkg15.jpg";
import bkg16 from "./bkg16.jpg";
import bkg17 from "./bkg17.jpg";
import bkg18 from "./bkg18.jpg";
import bkg19 from "./bkg19.jpg";
import bkg20 from "./bkg20.jpg";
import bkg21 from "./bkg21.jpg";
import bkg22 from "./bkg22.jpg";
import bkg23 from "./bkg23.jpg";
import bkg24 from "./bkg24.jpg";
import bkg25 from "./bkg25.jpg";
import bkg26 from "./bkg26.jpg";
import bkg27 from "./bkg27.jpg";
import bkg28 from "./bkg28.jpg";
import bkg29 from "./bkg29.jpg";
import bkg30 from "./bkg30.jpg";
import bkg31 from "./bkg31.jpg";
import bkg32 from "./bkg32.jpg";
import bkg33 from "./bkg33.jpg";
import bkg34 from "./bkg34.jpg";
import bkg35 from "./bkg35.jpg";
import bkg36 from "./bkg36.jpg";
import bkg37 from "./bkg37.jpg";
import bkg38 from "./bkg38.jpg";
import bkg39 from "./bkg39.jpg";
import bkg40 from "./bkg40.jpg";

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
    id: "palco-futurista",
    nome: "Futurista",
    categoria: "show",
    tipo: "imagem",
    src: bkg1,
    recomendadoPara: ["sertanejo-sunset"]
  },
  {
    id: "palco-teatro",
    nome: "Teatro",
    categoria: "show",
    tipo: "imagem",
    src: bkg2,
    recomendadoPara: ["sertanejo-sunset"]
  },
  {
    id: "neon-abstrato",
    nome: "Neon",
    categoria: "neon",
    tipo: "imagem",
    src: bkg3,
    recomendadoPara: ["sertanejo-sunset"]
  },
  {
    id: "festival-colorido",
    nome: "Colorido",
    categoria: "festival",
    tipo: "imagem",
    src: bkg4,
    recomendadoPara: ["sertanejo-sunset"]
  },
  {
    id: "show-cosmico",
    nome: "Cósmico",
    categoria: "show",
    tipo: "imagem",
    src: bkg5,
    recomendadoPara: ["sertanejo-sunset"]
  },
  {
    id: "arena-azul",
    nome: "Arena",
    categoria: "show",
    tipo: "imagem",
    src: bkg6,
    recomendadoPara: ["sertanejo-sunset"]
  },
  {
    id: "show-luzes-vibrantes",
    nome: "Vibrante",
    categoria: "show",
    tipo: "imagem",
    src: bkg7,
    recomendadoPara: ["sertanejo-sunset"]
  },
  {
    id: "festival-neon",
    nome: "Euforia",
    categoria: "festival",
    tipo: "imagem",
    src: bkg8,
    recomendadoPara: ["sertanejo-sunset"]
  },
  {
    id: "palco-laranja",
    nome: "Laranja",
    categoria: "show",
    tipo: "imagem",
    src: bkg9,
    recomendadoPara: ["sertanejo-sunset"]
  },
  {
    id: "palco-geometrico",
    nome: "Geométrico",
    categoria: "show",
    tipo: "imagem",
    src: bkg10,
    recomendadoPara: ["sertanejo-sunset"]
  },
  {
    id: "show-dourado",
    nome: "Dourado",
    categoria: "show",
    tipo: "imagem",
    src: bkg11,
    recomendadoPara: ["sertanejo-sunset"]
  },
  {
    id: "festival-luz-dourada",
    nome: "Solar",
    categoria: "festival",
    tipo: "imagem",
    src: bkg12,
    recomendadoPara: ["sertanejo-sunset"]
  },
  {
    id: "show-vermelho",
    nome: "Rubro",
    categoria: "show",
    tipo: "imagem",
    src: bkg13,
    recomendadoPara: ["sertanejo-sunset"]
  },
  {
    id: "palco-vermelho",
    nome: "Vermelho",
    categoria: "show",
    tipo: "imagem",
    src: bkg14,
    recomendadoPara: ["sertanejo-sunset"]
  },
  {
    id: "festa-tropical",
    nome: "Tropical",
    categoria: "festa",
    tipo: "imagem",
    src: bkg15,
    recomendadoPara: ["sertanejo-sunset"]
  },
  {
    id: "festival-por-do-sol",
    nome: "Sunset",
    categoria: "festival",
    tipo: "imagem",
    src: bkg16,
    recomendadoPara: ["sertanejo-sunset"]
  },
  {
    id: "festa-colorida",
    nome: "Alegria",
    categoria: "festa",
    tipo: "imagem",
    src: bkg17,
    recomendadoPara: ["sertanejo-sunset"]
  },
  {
    id: "festival-tropical",
    nome: "Verão",
    categoria: "festival",
    tipo: "imagem",
    src: bkg18,
    recomendadoPara: ["sertanejo-sunset"]
  },
  {
    id: "percussao-tropical",
    nome: "Percussão",
    categoria: "musica",
    tipo: "imagem",
    src: bkg19,
    recomendadoPara: ["sertanejo-sunset"]
  },
  {
    id: "percussao-brasileira",
    nome: "Brasil",
    categoria: "musica",
    tipo: "imagem",
    src: bkg20,
    recomendadoPara: ["sertanejo-sunset"]
  },
  {
    id: "guitarra-e-teclado",
    nome: "Instrumental",
    categoria: "musica",
    tipo: "imagem",
    src: bkg21,
    recomendadoPara: ["sertanejo-sunset"]
  },
  {
    id: "balada-disco",
    nome: "Disco",
    categoria: "balada",
    tipo: "imagem",
    src: bkg22,
    recomendadoPara: ["sertanejo-sunset"]
  },
  {
    id: "disco-microfone",
    nome: "Retrô",
    categoria: "balada",
    tipo: "imagem",
    src: bkg23,
    recomendadoPara: ["sertanejo-sunset"]
  },
  {
    id: "musica-neon",
    nome: "Neon Music",
    categoria: "musica",
    tipo: "imagem",
    src: bkg24,
    recomendadoPara: ["sertanejo-sunset"]
  },
  {
    id: "instrumentos-em-chamas",
    nome: "Fúria",
    categoria: "rock",
    tipo: "imagem",
    src: bkg25,
    recomendadoPara: ["sertanejo-sunset"]
  },
  {
    id: "bateria-no-palco",
    nome: "Bateria",
    categoria: "rock",
    tipo: "imagem",
    src: bkg26,
    recomendadoPara: ["sertanejo-sunset"]
  },
  {
    id: "guitarra-eletrica",
    nome: "Guitarra",
    categoria: "rock",
    tipo: "imagem",
    src: bkg27,
    recomendadoPara: ["sertanejo-sunset"]
  },
  {
    id: "rock-urbano",
    nome: "Urbano",
    categoria: "rock",
    tipo: "imagem",
    src: bkg28,
    recomendadoPara: ["sertanejo-sunset"]
  },
  {
    id: "rock-n-roll",
    nome: "Rock",
    categoria: "rock",
    tipo: "imagem",
    src: bkg29,
    recomendadoPara: ["sertanejo-sunset"]
  },
  {
    id: "country-rustico",
    nome: "Country",
    categoria: "country",
    tipo: "imagem",
    src: bkg30,
    recomendadoPara: ["sertanejo-sunset"]
  },
  {
    id: "palco-rustico",
    nome: "Rústico",
    categoria: "rustico",
    tipo: "imagem",
    src: bkg31,
    recomendadoPara: ["sertanejo-sunset"]
  },
  {
    id: "palco-ambar",
    nome: "Âmbar",
    categoria: "show",
    tipo: "imagem",
    src: bkg32,
    recomendadoPara: ["sertanejo-sunset"]
  },
  {
    id: "fundo-33",
    nome: "Fundo 33",
    categoria: "outros",
    tipo: "imagem",
    src: bkg33,
    recomendadoPara: ["sertanejo-sunset"]
  },
  {
    id: "tijolo-dourado",
    nome: "Tijolo",
    categoria: "restaurante",
    tipo: "imagem",
    src: bkg34,
    recomendadoPara: ["sertanejo-sunset"]
  },
  {
    id: "churrascaria-rustica",
    nome: "Churrasco",
    categoria: "restaurante",
    tipo: "imagem",
    src: bkg35,
    recomendadoPara: ["sertanejo-sunset"]
  },
  {
    id: "churrasco-e-cerveja",
    nome: "Boteco",
    categoria: "restaurante",
    tipo: "imagem",
    src: bkg36,
    recomendadoPara: ["sertanejo-sunset"]
  },
  {
    id: "pesqueiro-rustico",
    nome: "Pesqueiro",
    categoria: "pesqueiro",
    tipo: "imagem",
    src: bkg37,
    recomendadoPara: ["sertanejo-sunset"]
  },
  {
    id: "cerveja-gelada",
    nome: "Cerveja",
    categoria: "bar",
    tipo: "imagem",
    src: bkg38,
    recomendadoPara: ["sertanejo-sunset"]
  },
  {
    id: "brinde-de-cerveja",
    nome: "Brinde",
    categoria: "bar",
    tipo: "imagem",
    src: bkg39,
    recomendadoPara: ["sertanejo-sunset"]
  },
  {
    id: "rock-roxo",
    nome: "Purple Rock",
    categoria: "rock",
    tipo: "imagem",
    src: bkg40,
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
