# Integrantes:
# [Melany Yiseth Gomez Bacca]
# [David Cuellar Velez]
# [Isabella Ochoa Escobar]


defmodule Liquidacion do
  @tarifa_base 1800
  @litros_bonificacion 450
  @bonificacion_diaria 25_000
  @costo_transporte 18_000
  @dias_recepcion 6

  @doc """
  Calcula el valor de una entrega de leche.

  Primero calcula el valor base multiplicando los litros entregados
  por la tarifa base.

  Luego aplica un ajuste según el porcentaje de grasa:

  - 3.5 o más: bonificación del 6%.
  - 3.0 o más y menor de 3.5: sin ajuste.
  - 2.5 o más y menor de 3.0: descuento del 8%.
  - Menor de 2.5: descuento del 20%.

  Retorna el valor final de la entrega.
  """
  def valor_entrega(entrega) do
    valor_base = entrega.litros * @tarifa_base

    cond do
      entrega.grasa >= 3.5 ->
        valor_base * 1.06

      entrega.grasa >= 3.0 ->
        valor_base

      entrega.grasa >= 2.5 ->
        valor_base * 0.92

      true ->
        valor_base * 0.80
    end
  end

  @doc """
  Calcula la cantidad total de litros entregados por un productor
  en un día específico.

  Filtra las entregas utilizando el código del productor y el día,
  y posteriormente suma los litros encontrados.

  Retorna la cantidad total de litros entregados por el productor
  durante ese día.
  """
  def litros_productor_dia(entregas, codigo, dia) do
    entregas
    |> Enum.filter(fn entrega ->
      entrega.productor == codigo and
        entrega.dia == dia
    end)
    |> Enum.reduce(0, fn entrega, total ->
      total + entrega.litros
    end)
  end

  @doc """
  Calcula la bonificación diaria de un productor.

  Obtiene primero los litros entregados por el productor durante
  el día indicado.

  Si la cantidad de litros es mayor o igual al mínimo establecido
  para recibir bonificación, retorna el valor de la bonificación diaria.

  Si no alcanza el mínimo requerido, retorna 0.
  """
  def bonificacion_dia(entregas, codigo, dia) do
    litros = litros_productor_dia(entregas, codigo, dia)

    if litros >= @litros_bonificacion do
      @bonificacion_diaria
    else
      0
    end
  end

  @doc """
  Calcula el total de bonificaciones obtenidas por un productor.

  Recorre todos los días de recepción y calcula la bonificación
  correspondiente a cada día.

  Retorna la suma total de las bonificaciones obtenidas durante
  todos los días de recepción.
  """
  def bonificaciones_productor(entregas, codigo) do
    1..@dias_recepcion
    |> Enum.reduce(0, fn dia, total ->
      total + bonificacion_dia(entregas, codigo, dia)
    end)
  end

  @doc """
  Obtiene los días en los que un productor realizó al menos una entrega.

  Filtra las entregas correspondientes al código del productor,
  obtiene el día de cada una y elimina los días repetidos.

  Retorna una lista con los días únicos en los que el productor
  realizó entregas.
  """
  def dias_con_entrega(entregas, codigo) do
    entregas
    |> Enum.filter(fn entrega ->
      entrega.productor == codigo
    end)
    |> Enum.map(fn entrega ->
      entrega.dia
    end)
    |> Enum.uniq()
  end

  @doc """
  Calcula el descuento por transporte de un productor.

  Si el productor utiliza el servicio de transporte, obtiene
  la cantidad de días en los que realizó al menos una entrega
  y multiplica ese número por el costo diario del transporte.

  Si el productor no utiliza transporte, retorna 0.
  """
  def descuento_transporte(productor, entregas) do
    if productor.transporte do
      cantidad_dias =
        entregas
        |> dias_con_entrega(productor.codigo)
        |> length()

      cantidad_dias * @costo_transporte
    else
      0
    end
  end

  @doc """
  Calcula el valor total de las entregas realizadas por un productor.

  Filtra las entregas pertenecientes al productor indicado y calcula
  el valor de cada una utilizando valor_entrega/1.

  Finalmente suma todos los valores.

  Retorna el valor total de las entregas del productor.
  """
  def valor_entregas_productor(entregas, codigo) do
    entregas
    |> Enum.filter(fn entrega ->
      entrega.productor == codigo
    end)
    |> Enum.reduce(0, fn entrega, total ->
      total + valor_entrega(entrega)
    end)
  end

  @doc """
  Calcula la cantidad total de litros entregados por un productor.

  Filtra todas las entregas correspondientes al código del productor
  y suma la cantidad de litros de cada una.

  Retorna el total de litros entregados.
  """
  def litros_productor(entregas, codigo) do
    entregas
    |> Enum.filter(fn entrega ->
      entrega.productor == codigo
    end)
    |> Enum.reduce(0, fn entrega, total ->
      total + entrega.litros
    end)
  end

  @doc """
  Realiza la liquidación completa de un productor.

  Calcula:

  - Los litros totales entregados.
  - El valor total de las entregas.
  - Las bonificaciones obtenidas.
  - El descuento por transporte.
  - El valor neto a pagar.

  El valor neto se calcula sumando el valor de las entregas
  y las bonificaciones, y restando el transporte.

  Retorna un mapa con toda la información de la liquidación
  del productor.
  """
  def liquidar_productor(productor, entregas) do
    litros =
      litros_productor(
        entregas,
        productor.codigo
      )

    valor_entregas =
      valor_entregas_productor(
        entregas,
        productor.codigo
      )

    bonificaciones =
      bonificaciones_productor(
        entregas,
        productor.codigo
      )

    transporte =
      descuento_transporte(
        productor,
        entregas
      )

    neto =
      valor_entregas +
        bonificaciones -
        transporte

    %{
      codigo: productor.codigo,
      nombre: productor.nombre,
      litros: litros,
      valor_entregas: valor_entregas,
      bonificaciones: bonificaciones,
      transporte: transporte,
      neto: neto
    }
  end

  @doc """
  Realiza la liquidación de todos los productores.

  Recorre la colección de productores y utiliza
  liquidar_productor/2 para obtener la liquidación individual
  de cada uno.

  Retorna una lista con las liquidaciones de todos los productores.
  """
  def liquidar_todos(productores, entregas) do
    Enum.map(productores, fn productor ->
      liquidar_productor(productor, entregas)
    end)
  end

  @doc """
  Genera el detalle diario de entregas de un productor.

  Recorre todos los días de recepción y obtiene las entregas
  realizadas por el productor durante cada día.

  Para cada día calcula:

  - Los litros entregados.
  - El valor total de las entregas.
  - La bonificación correspondiente al día.

  Finalmente elimina los días en los que el productor no realizó
  ninguna entrega.

  Retorna una lista con el detalle de los días en los que el
  productor realizó entregas.
  """
  def detalle_diario(productor, entregas) do
    1..@dias_recepcion
    |> Enum.map(fn dia ->

      entregas_dia =
        Enum.filter(entregas, fn entrega ->
          entrega.productor == productor.codigo and
            entrega.dia == dia
        end)

      litros =
        Enum.reduce(entregas_dia, 0, fn entrega, total ->
          total + entrega.litros
        end)

      valor =
        Enum.reduce(entregas_dia, 0, fn entrega, total ->
          total + valor_entrega(entrega)
        end)

      bonificacion =
        bonificacion_dia(
          entregas,
          productor.codigo,
          dia
        )

      %{
        dia: dia,
        litros: litros,
        valor_entregas: valor,
        bonificacion: bonificacion
      }
    end)
    |> Enum.filter(fn detalle ->
      detalle.litros > 0
    end)
  end
end
