# Integrantes:
# [Melany Yiseth Gomez Bacca]
# [David Cuellar Velez]
# [Isabella Ochoa Escobar]


defmodule Principal do

  def main do
    productores = Datos.productores()
    tanques = Datos.tanques()

    entregas =
      Datos.entregas() ++
        Datos.entregas_invalidas()

    {validas, rechazadas} =
      Validacion.validar_todas(
        entregas,
        productores,
        tanques
      )

    {validas, rechazadas} =
      ingresar_entrega_adicional(
        validas,
        rechazadas,
        productores,
        tanques
      )

    mostrar_reportes(
      productores,
      tanques,
      validas,
      rechazadas
    )

    mostrar_comprobante(
      productores,
      validas
    )
  end


  @doc """
  Permite ingresar una entrega adicional antes de generar los reportes.

  Solicita al usuario una entrega con el formato:

      productor;tanque;dia;litros;grasa

  Si el usuario presiona Enter sin escribir información, conserva
  las listas actuales de entregas válidas y rechazadas.

  Si se ingresa información, primero convierte el texto en una
  entrega y posteriormente la valida.

  Si la entrega es válida, se agrega a la colección de entregas válidas.

  Si la entrega es rechazada, se agrega a la colección de rechazadas
  junto con el motivo correspondiente.

  Si el formato es incorrecto, muestra un mensaje de error.
  """
  defp ingresar_entrega_adicional(
         validas,
         rechazadas,
         productores,
         tanques
       ) do

    texto =
      Util.ingresar(
        "\nIngrese una entrega adicional\n" <>
          "(productor;tanque;dia;litros;grasa)\n" <>
          "o Enter para omitir: ",
        :texto
      )

    if texto == "" do
      {validas, rechazadas}
    else

      case Validacion.convertir_entrega(texto) do

        {:ok, entrega} ->

          case Validacion.validar_entrega(
                 entrega,
                 productores,
                 tanques
               ) do

            {:ok, entrega_valida} ->
              Util.mostrar(
                "\nEntrega agregada correctamente.",
                :mensaje
              )

              {
                validas ++ [entrega_valida],
                rechazadas
              }

            {:error, motivo} ->
              Util.mostrar(
                "\nEntrega rechazada: #{motivo}",
                :error
              )

              {
                validas,
                rechazadas ++ [{entrega, motivo}]
              }
          end

        {:error, :formato_invalido} ->
          Util.mostrar(
            "\nFormato de entrega inválido.",
            :error
          )

          {validas, rechazadas}
      end
    end
  end


  @doc """
  Muestra todos los reportes generados por el programa.

  Recibe los productores, tanques, entregas válidas y entregas
  rechazadas.

  Genera y muestra los reportes desde R1 hasta R8 utilizando
  las funciones del módulo Reportes y las funciones encargadas
  de presentar cada reporte en pantalla.
  """
  defp mostrar_reportes(
         productores,
         tanques,
         validas,
         rechazadas
       ) do

    mostrar_r1(rechazadas)

    mostrar_r2(
      Reportes.r2(
        tanques,
        validas
      )
    )

    mostrar_r3(
      Reportes.r3(
        validas
      )
    )

    mostrar_r4(
      Reportes.r4(
        productores,
        validas
      )
    )

    mostrar_r5(
      Reportes.r5(
        productores,
        validas
      )
    )

    mostrar_r6(
      Reportes.r6(
        productores,
        validas
      )
    )

    mostrar_r7(
      Reportes.r7(
        productores,
        validas
      )
    )

    mostrar_r8(
      Reportes.r8(
        productores,
        tanques,
        validas
      )
    )
  end


  @doc """
  Muestra el reporte R1 correspondiente a las entregas rechazadas.

  Presenta cada entrega rechazada junto con el motivo del rechazo.

  Después genera el conteo de rechazos y muestra la cantidad
  correspondiente a cada motivo.
  """
  defp mostrar_r1(rechazadas) do
    Util.mostrar(
      "\n========== R1 - ENTREGAS RECHAZADAS ==========\n",
      :mensaje
    )

    mensaje =
      rechazadas
      |> Util.convertir_coleccion_mensaje(
        fn {entrega, motivo} ->
          "#{inspect(entrega)} -> #{motivo}\n"
        end
      )
      |> Enum.join()

    Util.mostrar(mensaje, :mensaje)

    reporte = Reportes.r1(rechazadas)

    Util.mostrar(
      "\nCantidad por motivo:",
      :mensaje
    )

    Enum.each(
      reporte.conteo,
      fn {motivo, cantidad} ->
        Util.mostrar(
          "#{motivo}: #{cantidad}",
          :mensaje
        )
      end
    )
  end


  @doc """
  Muestra el reporte R2 correspondiente a la ocupación de los tanques.

  Para cada tanque muestra:

  - El nombre del tanque.
  - Los litros almacenados.
  - El porcentaje de ocupación.

  El porcentaje se presenta redondeado a dos cifras decimales.
  """
  defp mostrar_r2(reporte) do
    Util.mostrar(
      "\n========== R2 - TANQUES ==========\n",
      :mensaje
    )

    mensaje =
      reporte
      |> Util.convertir_coleccion_mensaje(
        fn tanque ->
          "#{tanque.nombre}: " <>
            "#{tanque.litros} litros - " <>
            "#{Float.round(tanque.porcentaje, 2)}%\n"
        end
      )
      |> Enum.join()

    Util.mostrar(mensaje, :mensaje)
  end


  @doc """
  Muestra el reporte R3 correspondiente a los litros recibidos
  durante cada día.

  Para cada día presenta la cantidad de litros recibidos y muestra
  si se alcanzó o no la meta diaria.

  También indica al final:

  - Si la meta se cumplió todos los días.
  - Si la meta se cumplió al menos un día.
  """
  defp mostrar_r3(reporte) do
    Util.mostrar(
      "\n========== R3 - LITROS POR DÍA ==========\n",
      :mensaje
    )

    mensaje =
      reporte.dias
      |> Util.convertir_coleccion_mensaje(
        fn dato ->
          estado =
            if dato.meta do
              "Meta cumplida"
            else
              "Meta no cumplida"
            end

          "Día #{dato.dia}: " <>
            "#{dato.litros} litros - " <>
            "#{estado}\n"
        end
      )
      |> Enum.join()

    Util.mostrar(mensaje, :mensaje)

    Util.mostrar(
      "¿Se cumplió todos los días?: " <>
        "#{reporte.cumplio_todos}",
      :mensaje
    )

    Util.mostrar(
      "¿Se cumplió al menos un día?: " <>
        "#{reporte.cumplio_alguno}",
      :mensaje
    )
  end


  @doc """
  Muestra el reporte R4 correspondiente a la liquidación
  de todos los productores.

  Para cada productor muestra:

  - Su posición.
  - Su nombre.
  - Los litros entregados.
  - El valor de las entregas.
  - Las bonificaciones.
  - El descuento por transporte.
  - El valor neto a pagar.
  """
  defp mostrar_r4(reporte) do
    Util.mostrar(
      "\n========== R4 - LIQUIDACIÓN ==========\n",
      :mensaje
    )

    Enum.each(
      reporte,
      fn {liquidacion, posicion} ->

        Util.mostrar(
          "#{posicion}. " <>
            "#{liquidacion.nombre} - " <>
            "Litros: #{liquidacion.litros} - " <>
            "Entregas: $#{Float.round(liquidacion.valor_entregas * 1.0, 2)} - " <>
            "Bonificaciones: $#{liquidacion.bonificaciones} - " <>
            "Transporte: $#{liquidacion.transporte} - " <>
            "Neto: $#{Float.round(liquidacion.neto * 1.0, 2)}",
          :mensaje
        )
      end
    )
  end


  @doc """
  Muestra el reporte R5 correspondiente a los productores
  con mayor cantidad de litros entregados por día.

  Para cada día muestra el productor o productores que ocuparon
  el primer lugar junto con la cantidad de litros entregados.

  Al final presenta el productor o productores que ocuparon
  el primer lugar durante más días.
  """
  defp mostrar_r5(reporte) do
    Util.mostrar(
      "\n========== R5 - MAYOR ENTREGA POR DÍA ==========\n",
      :mensaje
    )

    Enum.each(
      reporte.dias,
      fn dia ->

        nombres =
          dia.ganadores
          |> Enum.map(fn productor ->
            productor.nombre
          end)
          |> Enum.join(", ")

        Util.mostrar(
          "Día #{dia.dia}: " <>
            "#{nombres} - " <>
            "#{dia.litros} litros",
          :mensaje
        )
      end
    )

    nombres =
      reporte.ganadores_semana
      |> Enum.map(fn productor ->
        productor.nombre
      end)
      |> Enum.join(", ")

    Util.mostrar(
      "\nPrimer lugar en más días: " <>
        "#{nombres} " <>
        "(#{reporte.max_dias} días)",
      :mensaje
    )
  end


  @doc """
  Muestra el reporte R6 correspondiente al productor con mejor
  calidad de leche.

  Presenta el nombre del productor y su porcentaje de grasa
  ponderada.

  Si no existen productores con al menos tres entregas válidas,
  muestra un mensaje informándolo.
  """
  defp mostrar_r6(reporte) do
    Util.mostrar(
      "\n========== R6 - MEJOR CALIDAD ==========\n",
      :mensaje
    )

    if reporte == [] do
      Util.mostrar(
        "No hay productores con mínimo 3 entregas.",
        :mensaje
      )
    else
      Enum.each(
        reporte,
        fn productor ->
          Util.mostrar(
            "#{productor.nombre}: " <>
              "#{Float.round(productor.grasa_ponderada, 3)}% grasa ponderada",
            :mensaje
          )
        end
      )
    end
  end


  @doc """
  Muestra el reporte R7 correspondiente al total pagado
  por el centro durante la semana.

  Presenta:

  - El total de dinero pagado.
  - El costo promedio pagado por litro.

  Los valores se muestran redondeados a dos cifras decimales.
  """
  defp mostrar_r7(reporte) do
    Util.mostrar(
      "\n========== R7 - TOTAL PAGADO ==========\n",
      :mensaje
    )

    Util.mostrar(
      "Total pagado: $" <>
        "#{Float.round(reporte.total_pagado * 1.0, 2)}",
      :mensaje
    )

    Util.mostrar(
      "Costo promedio por litro: $" <>
        "#{Float.round(reporte.promedio_litro * 1.0, 2)}",
      :mensaje
    )
  end


  @doc """
  Muestra el reporte R8 correspondiente a los productores
  que realizaron entregas válidas en todos los tanques.

  Presenta el código y el nombre de cada productor que cumple
  con esta condición.
  """
  defp mostrar_r8(reporte) do
    Util.mostrar(
      "\n========== R8 - TODOS LOS TANQUES ==========\n",
      :mensaje
    )

    mensaje =
      reporte
      |> Util.convertir_coleccion_mensaje(
        fn productor ->
          "#{productor.codigo} - #{productor.nombre}\n"
        end
      )
      |> Enum.join()

    Util.mostrar(mensaje, :mensaje)
  end


  @doc """
  Solicita el código de un productor y muestra su comprobante.

  Busca el productor utilizando el código ingresado por el usuario.

  Si el productor no existe, muestra un mensaje de error.

  Si existe, calcula su liquidación y muestra:

  - Nombre y código.
  - Información de cada día con entregas.
  - Litros entregados.
  - Valor de las entregas.
  - Bonificación diaria.
  - Total de litros.
  - Total de entregas.
  - Total de bonificaciones.
  - Descuento por transporte.
  - Neto a pagar.
  """
  defp mostrar_comprobante(
         productores,
         entregas
       ) do

    codigo =
      Util.ingresar(
        "\nIngrese el código del productor para generar comprobante: ",
        :texto
      )

    productor =
      Enum.find(
        productores,
        fn productor ->
          productor.codigo == codigo
        end
      )

    if is_nil(productor) do

      Util.mostrar(
        "El productor no existe.",
        :error
      )

    else

      liquidacion =
        Liquidacion.liquidar_productor(
          productor,
          entregas
        )

      detalles =
        Liquidacion.detalle_diario(
          productor,
          entregas
        )

      Util.mostrar(
        "\n========== COMPROBANTE ==========",
        :mensaje
      )

      Util.mostrar(
        "#{productor.nombre} - #{productor.codigo}",
        :mensaje
      )

      Enum.each(
        detalles,
        fn detalle ->

          Util.mostrar(
            "Día #{detalle.dia}: " <>
              "#{detalle.litros} litros | " <>
              "Valor: $#{Float.round(detalle.valor_entregas * 1.0, 2)} | " <>
              "Bonificación: $#{detalle.bonificacion}",
            :mensaje
          )
        end
      )

      Util.mostrar(
        "\nTotal litros: #{liquidacion.litros}",
        :mensaje
      )

      Util.mostrar(
        "Total entregas: $" <>
          "#{Float.round(liquidacion.valor_entregas * 1.0, 2)}",
        :mensaje
      )

      Util.mostrar(
        "Total bonificaciones: $" <>
          "#{liquidacion.bonificaciones}",
        :mensaje
      )

      Util.mostrar(
        "Transporte: $" <>
          "#{liquidacion.transporte}",
        :mensaje
      )

      Util.mostrar(
        "NETO A PAGAR: $" <>
          "#{Float.round(liquidacion.neto * 1.0, 2)}",
        :mensaje
      )
    end
  end
end

Principal.main()
