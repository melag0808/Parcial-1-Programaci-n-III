# Integrantes:
# [Melany Yiseth Gomez Bacca]
# [David Cuellar Velez]
# [Isabella Ochoa Escobar]


defmodule Datos do
  def productores do
    [
      %{codigo: "P01", nombre: "Marta Gomez", transporte: true},
      %{codigo: "P02", nombre: "Luis Cardona", transporte: true},
      %{codigo: "P03", nombre: "Ana Lopez", transporte: true},
      %{codigo: "P04", nombre: "Carlos Rojas", transporte: true},
      %{codigo: "P05", nombre: "Laura Castro", transporte: false},
      %{codigo: "P06", nombre: "Pedro Gomez", transporte: false},
      %{codigo: "P07", nombre: "Sofia Marin", transporte: false},
      %{codigo: "P08", nombre: "Diego Arias", transporte: false},
      %{codigo: "P09", nombre: "Valentina Ruiz", transporte: false},
      %{codigo: "P10", nombre: "Juan Torres", transporte: false}
    ]
  end

  def tanques do
    [
      %{id: "T1", nombre: "Tanque Norte", capacidad: 5000},
      %{id: "T2", nombre: "Tanque Central", capacidad: 4500},
      %{id: "T3", nombre: "Tanque Sur", capacidad: 4000},
      %{id: "T4", nombre: "Tanque Occidente", capacidad: 3500}
    ]
  end

  def entregas do
    [
      %{productor: "P01", tanque: "T1", dia: 1, litros: 245, grasa: 3.8},
      %{productor: "P01", tanque: "T2", dia: 1, litros: 234, grasa: 2.9},
      %{productor: "P01", tanque: "T3", dia: 2, litros: 303, grasa: 3.4},
      %{productor: "P01", tanque: "T4", dia: 3, litros: 185, grasa: 2.7},
      %{productor: "P01", tanque: "T1", dia: 4, litros: 502, grasa: 3.6},
      %{productor: "P01", tanque: "T2", dia: 5, litros: 354, grasa: 3.1},
      %{productor: "P01", tanque: "T3", dia: 6, litros: 422, grasa: 2.4},
      %{productor: "P01", tanque: "T4", dia: 2, litros: 263, grasa: 3.9},

      %{productor: "P02", tanque: "T1", dia: 1, litros: 250, grasa: 3.8},
      %{productor: "P02", tanque: "T2", dia: 1, litros: 238, grasa: 2.9},
      %{productor: "P02", tanque: "T3", dia: 2, litros: 306, grasa: 3.4},
      %{productor: "P02", tanque: "T4", dia: 3, litros: 190, grasa: 2.7},
      %{productor: "P02", tanque: "T1", dia: 4, litros: 504, grasa: 3.6},
      %{productor: "P02", tanque: "T2", dia: 5, litros: 358, grasa: 3.1},
      %{productor: "P02", tanque: "T3", dia: 6, litros: 424, grasa: 2.4},
      %{productor: "P02", tanque: "T4", dia: 2, litros: 266, grasa: 3.9},

      %{productor: "P03", tanque: "T1", dia: 1, litros: 255, grasa: 3.8},
      %{productor: "P03", tanque: "T2", dia: 1, litros: 242, grasa: 2.9},
      %{productor: "P03", tanque: "T3", dia: 2, litros: 309, grasa: 3.4},
      %{productor: "P03", tanque: "T4", dia: 3, litros: 195, grasa: 2.7},
      %{productor: "P03", tanque: "T1", dia: 4, litros: 506, grasa: 3.6},
      %{productor: "P03", tanque: "T2", dia: 5, litros: 362, grasa: 3.1},
      %{productor: "P03", tanque: "T3", dia: 6, litros: 426, grasa: 2.4},
      %{productor: "P03", tanque: "T4", dia: 2, litros: 269, grasa: 3.9},

      %{productor: "P04", tanque: "T1", dia: 1, litros: 260, grasa: 3.8},
      %{productor: "P04", tanque: "T2", dia: 1, litros: 246, grasa: 2.9},
      %{productor: "P04", tanque: "T3", dia: 2, litros: 312, grasa: 3.4},
      %{productor: "P04", tanque: "T4", dia: 3, litros: 200, grasa: 2.7},
      %{productor: "P04", tanque: "T1", dia: 4, litros: 508, grasa: 3.6},
      %{productor: "P04", tanque: "T2", dia: 5, litros: 366, grasa: 3.1},
      %{productor: "P04", tanque: "T3", dia: 6, litros: 428, grasa: 2.4},
      %{productor: "P04", tanque: "T4", dia: 2, litros: 272, grasa: 3.9},

      %{productor: "P05", tanque: "T1", dia: 1, litros: 265, grasa: 3.8},
      %{productor: "P05", tanque: "T2", dia: 1, litros: 250, grasa: 2.9},
      %{productor: "P05", tanque: "T3", dia: 2, litros: 315, grasa: 3.4},
      %{productor: "P05", tanque: "T4", dia: 3, litros: 205, grasa: 2.7},
      %{productor: "P05", tanque: "T1", dia: 4, litros: 510, grasa: 3.6},
      %{productor: "P05", tanque: "T2", dia: 5, litros: 370, grasa: 3.1},
      %{productor: "P05", tanque: "T3", dia: 6, litros: 430, grasa: 2.4},
      %{productor: "P05", tanque: "T4", dia: 2, litros: 275, grasa: 3.9},

      %{productor: "P06", tanque: "T1", dia: 1, litros: 270, grasa: 3.8},
      %{productor: "P06", tanque: "T2", dia: 1, litros: 254, grasa: 2.9},
      %{productor: "P06", tanque: "T3", dia: 2, litros: 318, grasa: 3.4},
      %{productor: "P06", tanque: "T4", dia: 3, litros: 210, grasa: 2.7},
      %{productor: "P06", tanque: "T1", dia: 4, litros: 512, grasa: 3.6},
      %{productor: "P06", tanque: "T2", dia: 5, litros: 374, grasa: 3.1},
      %{productor: "P06", tanque: "T3", dia: 6, litros: 432, grasa: 2.4},
      %{productor: "P06", tanque: "T4", dia: 2, litros: 278, grasa: 3.9},

      %{productor: "P07", tanque: "T1", dia: 1, litros: 275, grasa: 3.8},
      %{productor: "P07", tanque: "T2", dia: 1, litros: 258, grasa: 2.9},
      %{productor: "P07", tanque: "T3", dia: 2, litros: 321, grasa: 3.4},
      %{productor: "P07", tanque: "T4", dia: 3, litros: 215, grasa: 2.7},
      %{productor: "P07", tanque: "T1", dia: 4, litros: 514, grasa: 3.6},
      %{productor: "P07", tanque: "T2", dia: 5, litros: 378, grasa: 3.1},
      %{productor: "P07", tanque: "T3", dia: 6, litros: 434, grasa: 2.4},
      %{productor: "P07", tanque: "T4", dia: 2, litros: 281, grasa: 3.9},

      %{productor: "P08", tanque: "T1", dia: 1, litros: 280, grasa: 3.8},
      %{productor: "P08", tanque: "T2", dia: 1, litros: 262, grasa: 2.9},
      %{productor: "P08", tanque: "T3", dia: 2, litros: 324, grasa: 3.4},
      %{productor: "P08", tanque: "T4", dia: 3, litros: 220, grasa: 2.7},
      %{productor: "P08", tanque: "T1", dia: 4, litros: 516, grasa: 3.6},
      %{productor: "P08", tanque: "T2", dia: 5, litros: 382, grasa: 3.1},
      %{productor: "P08", tanque: "T3", dia: 6, litros: 436, grasa: 2.4},
      %{productor: "P08", tanque: "T4", dia: 2, litros: 284, grasa: 3.9},

      %{productor: "P09", tanque: "T1", dia: 1, litros: 285, grasa: 3.8},
      %{productor: "P09", tanque: "T2", dia: 1, litros: 266, grasa: 2.9},
      %{productor: "P09", tanque: "T3", dia: 2, litros: 327, grasa: 3.4},
      %{productor: "P09", tanque: "T4", dia: 3, litros: 225, grasa: 2.7},
      %{productor: "P09", tanque: "T1", dia: 4, litros: 518, grasa: 3.6},
      %{productor: "P09", tanque: "T2", dia: 5, litros: 386, grasa: 3.1},
      %{productor: "P09", tanque: "T3", dia: 6, litros: 438, grasa: 2.4},
      %{productor: "P09", tanque: "T4", dia: 2, litros: 287, grasa: 3.9},

      %{productor: "P10", tanque: "T1", dia: 1, litros: 290, grasa: 3.8},
      %{productor: "P10", tanque: "T2", dia: 1, litros: 270, grasa: 2.9},
      %{productor: "P10", tanque: "T3", dia: 2, litros: 330, grasa: 3.4},
      %{productor: "P10", tanque: "T4", dia: 3, litros: 230, grasa: 2.7},
      %{productor: "P10", tanque: "T1", dia: 4, litros: 520, grasa: 3.6},
      %{productor: "P10", tanque: "T2", dia: 5, litros: 390, grasa: 3.1},
      %{productor: "P10", tanque: "T3", dia: 6, litros: 440, grasa: 2.4},
      %{productor: "P10", tanque: "T4", dia: 2, litros: 290, grasa: 3.9}
    ]
  end

  def entregas_invalidas do
    [
      # Productor desconocido
      %{productor: "P99", tanque: "T1", dia: 1, litros: 200, grasa: 3.5},
      %{productor: "P98", tanque: "T2", dia: 2, litros: 300, grasa: 3.2},

      # Tanque desconocido
      %{productor: "P01", tanque: "T99", dia: 1, litros: 200, grasa: 3.5},
      %{productor: "P02", tanque: "T98", dia: 2, litros: 300, grasa: 3.2},

      # Dia invalido
      %{productor: "P03", tanque: "T1", dia: 0, litros: 200, grasa: 3.5},
      %{productor: "P04", tanque: "T2", dia: 7, litros: 300, grasa: 3.2},

      # Litros fuera de rango
      %{productor: "P05", tanque: "T1", dia: 1, litros: 0, grasa: 3.5},
      %{productor: "P06", tanque: "T2", dia: 2, litros: 801, grasa: 3.2},

      # Porcentaje invalido
      %{productor: "P07", tanque: "T1", dia: 1, litros: 200, grasa: -1},
      %{productor: "P08", tanque: "T2", dia: 2, litros: 300, grasa: 16}
    ]
  end
end
