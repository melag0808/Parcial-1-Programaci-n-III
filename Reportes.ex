# Integrantes:
# [Melany Yiseth Gomez Bacca]
# [David Cuellar Velez]
# [Isabella Ochoa Escobar]


defmodule Reportes do
  @meta_diaria 2000
  @dias_recepcion 6

  @doc """
  Genera el reporte R1 de entregas rechazadas.

  Recibe la colección de entregas rechazadas junto con el motivo
  correspondiente a cada rechazo.

  Cuenta cuántas entregas fueron rechazadas por cada motivo
  utilizando un mapa como acumulador.

  Retorna un mapa con:

  - Las entregas rechazadas.
  - La cantidad de rechazos por cada motivo.
  """
  def r1(rechazadas) do
    conteo =
      Enum.reduce(rechazadas, %{}, fn {_entrega, motivo}, acumulador ->
        Map.update(
          acumulador,
          motivo,
          1,
          fn cantidad -> cantidad + 1 end
        )
      end)

    %{
      rechazadas: rechazadas,
      conteo: conteo
    }
  end


  @doc """
  Genera el reporte R2 de ocupación de los tanques.

  Recibe la colección de tanques y las entregas válidas.

  Para cada tanque calcula:

  - Los litros almacenados.
  - La capacidad total del tanque.
  - El porcentaje de ocupación.

  Los tanques se ordenan de mayor a menor según su porcentaje
  de ocupación.

  Retorna una lista con la información calculada de cada tanque.
  """
  def r2(tanques, entregas) do
    tanques
    |> Enum.map(fn tanque ->

      litros =
        entregas
        |> Enum.filter(fn entrega ->
          entrega.tanque == tanque.id
        end)
        |> Enum.reduce(0, fn entrega, total ->
          total + entrega.litros
        end)

      porcentaje =
        litros / tanque.capacidad * 100

      %{
        id: tanque.id,
        nombre: tanque.nombre,
        capacidad: tanque.capacidad,
        litros: litros,
        porcentaje: porcentaje
      }
    end)
    |> Util.ordenar(:desc, & &1.porcentaje)
  end

  @doc """
  Genera el reporte R3 de litros recibidos por día.

  Recorre los días de recepción y calcula la cantidad total
  de litros recibidos en cada día.

  También determina si cada día alcanzó la meta diaria establecida.

  Al final verifica:

  - Si la meta se cumplió todos los días.
  - Si la meta se cumplió al menos un día.

  Retorna un mapa con la información diaria y los resultados
  generales del cumplimiento de la meta.
  """
  def r3(entregas) do
    dias =
      Enum.map(1..@dias_recepcion, fn dia ->

        litros =
          entregas
          |> Enum.filter(fn entrega ->
            entrega.dia == dia
          end)
          |> Enum.reduce(0, fn entrega, total ->
            total + entrega.litros
          end)

        %{
          dia: dia,
          litros: litros,
          meta: litros >= @meta_diaria
        }
      end)

    %{
      dias: dias,
      cumplio_todos:
        Enum.all?(dias, fn dia ->
          dia.meta
        end),
      cumplio_alguno:
        Enum.any?(dias, fn dia ->
          dia.meta
        end)
    }
  end


  @doc """
  Genera un mapa con los litros totales recibidos en cada día.

  Utiliza la información obtenida en el reporte R3 y transforma
  la lista de días en un mapa.

  La clave corresponde al número del día y el valor corresponde
  a los litros recibidos en ese día.

  Ejemplo:

      %{
        1 => 2500,
        2 => 1800
      }

  Este mapa se utiliza posteriormente para combinar la información
  del centro con la información de otro centro mediante Map.merge/3.
  """
  def mapa_litros_diarios(entregas) do
    r3(entregas).dias
    |> Map.new(fn dato ->
      {dato.dia, dato.litros}
    end)
  end


  @doc """
  Ordena una colección de mapas según opciones en una keyword list.

  Opciones:

  - :campo: clave del mapa usada para ordenar. Por defecto, :neto.
  - :orden: :asc o :desc. Por defecto, :desc.

  Ejemplo:

      ranking(liquidaciones, [campo: :neto, orden: :desc])
  """
  def ranking(coleccion, opciones) when is_list(opciones) do
    campo = Keyword.get(opciones, :campo, :neto)
    orden = Keyword.get(opciones, :orden, :desc)

    Enum.sort_by(
      coleccion,
      fn elemento -> Map.get(elemento, campo) end,
      orden
    )
  end

  @doc """
  Genera el reporte R4 de liquidación de productores.

  Recibe la colección de productores y las entregas válidas.

  Primero obtiene la liquidación de todos los productores utilizando
  Liquidacion.liquidar_todos/2.

  Posteriormente ordena las liquidaciones de mayor a menor según
  el valor neto y agrega una posición numérica a cada productor.

  Retorna la liquidación ordenada y numerada.
  """
  def r4(productores, entregas) do
    liquidaciones = Liquidacion.liquidar_todos(productores, entregas)

    liquidaciones
    |> ranking([campo: :neto, orden: :desc])
    |> Enum.with_index(1)
  end

  @doc """
  Genera el reporte R5 del productor con mayor cantidad
  de litros entregados cada día.

  Para cada día calcula los litros entregados por cada productor
  y determina cuál fue la mayor cantidad registrada.

  Si varios productores tienen la misma cantidad máxima de litros,
  todos aparecen como ganadores de ese día.

  También cuenta cuántas veces cada productor ocupó el primer lugar
  y determina quién o quiénes fueron primeros en más días.

  Retorna un mapa con:

  - Los resultados diarios.
  - El conteo de primeros lugares.
  - La mayor cantidad de días obtenida.
  - Los productores que ocuparon el primer lugar más veces.
  """
  def r5(productores, entregas) do
    resultados =
      Enum.map(1..@dias_recepcion, fn dia ->

        totales =
          Enum.map(productores, fn productor ->

            litros =
              Liquidacion.litros_productor_dia(
                entregas,
                productor.codigo,
                dia
              )

            %{
              codigo: productor.codigo,
              nombre: productor.nombre,
              litros: litros
            }
          end)

        mayor =
          totales
          |> Enum.max_by(& &1.litros)
          |> Map.get(:litros)

        ganadores =
          Enum.filter(totales, fn productor ->
            productor.litros == mayor
          end)

        %{
          dia: dia,
          litros: mayor,
          ganadores: ganadores
        }
      end)

    conteo_primeros =
      resultados
      |> Enum.flat_map(fn resultado ->
        resultado.ganadores
      end)
      |> Enum.reduce(%{}, fn productor, acumulador ->
        Map.update(
          acumulador,
          productor.codigo,
          1,
          fn cantidad -> cantidad + 1 end
        )
      end)

    max_dias =
      if map_size(conteo_primeros) == 0 do
        0
      else
        conteo_primeros
        |> Map.values()
        |> Enum.max()
      end

    ganadores_semana =
      productores
      |> Enum.filter(fn productor ->
        Map.get(conteo_primeros, productor.codigo, 0) == max_dias
      end)

    %{
      dias: resultados,
      conteo: conteo_primeros,
      max_dias: max_dias,
      ganadores_semana: ganadores_semana
    }
  end

  @doc """
  Genera el reporte R6 del productor con mejor calidad de leche.

  Solamente tiene en cuenta productores que tengan al menos
  tres entregas válidas.

  Para cada productor calcula el porcentaje de grasa ponderado
  según la cantidad de litros entregados.

  La fórmula utilizada es:

      suma(grasa * litros) / suma(litros)

  Después identifica el mayor porcentaje de grasa ponderada.

  Si varios productores tienen el mismo valor máximo, todos
  son incluidos en el resultado.

  Retorna una lista con el productor o productores de mejor calidad.
  """
  def r6(productores, entregas) do
    resultados =
      productores
      |> Enum.map(fn productor ->

        entregas_productor =
          Enum.filter(entregas, fn entrega ->
            entrega.productor == productor.codigo
          end)

        if length(entregas_productor) >= 3 do

          suma_ponderada =
            Enum.reduce(
              entregas_productor,
              0,
              fn entrega, total ->
                total + entrega.grasa * entrega.litros
              end
            )

          litros =
            Enum.reduce(
              entregas_productor,
              0,
              fn entrega, total ->
                total + entrega.litros
              end
            )

          %{
            codigo: productor.codigo,
            nombre: productor.nombre,
            entregas: length(entregas_productor),
            grasa_ponderada: suma_ponderada / litros
          }
        else
          nil
        end
      end)
      |> Enum.reject(&is_nil/1)

    if resultados == [] do
      []
    else
      mejor =
        resultados
        |> Enum.max_by(& &1.grasa_ponderada)
        |> Map.get(:grasa_ponderada)

      Enum.filter(resultados, fn productor ->
        productor.grasa_ponderada == mejor
      end)
    end
  end

  @doc """
  Genera el reporte R7 del total pagado por el centro.

  Obtiene primero las liquidaciones de todos los productores.

  Después calcula:

  - El total de dinero pagado durante la semana.
  - La cantidad total de litros recibidos.
  - El costo promedio pagado por cada litro.

  Si no existen litros recibidos, el promedio se establece en cero
  para evitar una división entre cero.

  Retorna un mapa con el total pagado, los litros recibidos
  y el promedio pagado por litro.
  """
  def r7(productores, entregas) do
    liquidaciones =
      Liquidacion.liquidar_todos(
        productores,
        entregas
      )

    total_pagado =
      Enum.reduce(
        liquidaciones,
        0,
        fn liquidacion, total ->
          total + liquidacion.neto
        end
      )

    litros =
      Enum.reduce(
        entregas,
        0,
        fn entrega, total ->
          total + entrega.litros
        end
      )

    promedio =
      if litros > 0 do
        total_pagado / litros
      else
        0
      end

    %{
      total_pagado: total_pagado,
      litros: litros,
      promedio_litro: promedio
    }
  end

  @doc """
  Genera el reporte R8 de productores que realizaron entregas
  en todos los tanques.

  Primero obtiene los identificadores de todos los tanques.

  Posteriormente revisa cada productor y verifica que exista
  al menos una entrega suya en cada uno de los tanques.

  Retorna una lista con los productores que cumplen esta condición.
  """
  def r8(productores, tanques, entregas) do
    ids_tanques =
      Enum.map(tanques, fn tanque ->
        tanque.id
      end)

    Enum.filter(productores, fn productor ->

      Enum.all?(ids_tanques, fn tanque ->

        Enum.any?(entregas, fn entrega ->
          entrega.productor == productor.codigo and
            entrega.tanque == tanque
        end)

      end)
    end)
  end


  @doc """
  Combina el mapa de litros diarios del centro con el mapa
  de litros diarios de otro centro.

  Utiliza Map.merge/3 para combinar ambos mapas.

  Cuando un mismo día aparece en los dos mapas, suma la cantidad
  de litros de ambos centros.

  Si una clave solamente existe en uno de los mapas, se conserva
  el valor correspondiente a ese mapa.

  Retorna un nuevo mapa con los litros combinados de ambos centros.
  """
  def combinar_centros(mapa_centro, mapa_vecino) do
    Map.merge(
      mapa_centro,
      mapa_vecino,
      fn _dia, litros_centro, litros_vecino ->
        litros_centro + litros_vecino
      end
    )
  end
end
