class Juguete {

	var property cuv

	method costoFabricacion()

	method eficacia()

	method precio() = (self.eficacia() * 10) + self.costoFabricacion()

}

class Pelota inherits Juguete {

	var property radio

	override method costoFabricacion() = 3 * radio * cuv

	override method precio() = (self.eficacia() * 10) + self.costoFabricacion()

	override method eficacia() = 12

}

class JugueteConPiezas inherits Juguete {

	var property piezas = []

	method laDeMayorVolumen() = piezas.max({ p => p.volumen() })

	method agregarPieza(_pieza) {
		piezas.add(_pieza)
	}

	method costoFijo() = 5

	method cuantasPiezas() = piezas.size()

	override method costoFabricacion() {
		return self.costoFijo() + (self.laDeMayorVolumen().volumen() * self.cuantasPiezas() * cuv )
	}

	override method eficacia() = 3 * self.cuantasPiezas()

	override method precio() {
		return super() + self.impuestoRosa()
	}

	method tienePiezasRosas() = piezas.any({ p => p.color() == "rosa" })

	method impuestoRosa() {
		return if (self.tienePiezasRosas()) 20 else 0
	}

}

class Baldecito inherits JugueteConPiezas {

}

class Pieza {

	var property volumen
	var property color

	method eficacia() = volumen

}

class Tachito inherits JugueteConPiezas {

	override method costoFijo() = 3

	override method costoFabricacion() = self.costoFijo() + (self.laDeMayorVolumen().volumen() * (self.cuantasPiezas() * cuv) )

	override method eficacia() = piezas.sum({ p => p.eficacia() })

}

/* --------------------NIÑOS-------------------------*/
class NinioTipico {

	var property edad
	var property listaDeJuguetes = []

	method meEntretiene(_juguete) = _juguete.eficacia( ) * self.coeficiente()

	method coeficiente() = 1 + self.edad() / 100

	method aceptaJuguete(_juguete) {
		return true
	}

	method recibirJuguete(juguete) {
		if (self.aceptaJuguete(juguete)) {
			listaDeJuguetes.add(juguete)
		}
	}

	method aceptaDonaciones(receptor) {
		return listaDeJuguetes.any({ juguete => receptor.aceptaJuguete(juguete) })
	}

	method validaPuedeDonar(receptor) {
		if (not self.aceptaDonaciones(receptor)) {
			self.error("el receptor no acepta ningún juguete. ")
		}
	}

	method donar(receptor) {
		self.validaPuedeDonar(receptor)
			// forEach
//		listaDeJuguetes.forEach({ juguete =>
//			if (receptor.aceptaJuguete(juguete)) {
//				receptor.recibirJuguete(juguete)
//				listaDeJuguetes.remove(juguete)
//			}
//		})
			// filter
		const juguetesQueAcepta = listaDeJuguetes.filter({ juguete => receptor.aceptaJuguete(juguete) })
		receptor.aceptarDonacion(juguetesQueAcepta)
		listaDeJuguetes.removeAll(juguetesQueAcepta)
	}

	method aceptarDonacion(donacion) {
		listaDeJuguetes.addAll(donacion)
	}

}

class Curioso inherits NinioTipico {

	override method meEntretiene(_juguete) = super(_juguete) * 1.5

	override method aceptaJuguete(_juguete) = _juguete.precio() <= 150

}

class Revoltoso inherits NinioTipico {

	override method meEntretiene(_juguete) = super(_juguete) * 0.5

	override method aceptaJuguete(_juguete) = self.meEntretiene(_juguete) > 7

}

