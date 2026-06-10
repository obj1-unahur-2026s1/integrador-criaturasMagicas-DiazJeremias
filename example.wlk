object parqueEncantado {

}


class Criatura{
 var poderMagico
 var astucia
 var rol

 method rol() {
  return rol
 }
 method setRol(nuevoRol) {
  rol = nuevoRol
 }
 method perder15DePoder() {
  poderMagico -= 15
 }
 method poderMagico() {
  return poderMagico
 }
 method esAstuta()
 method esExtraordinaria()
 method esFormidable() {
  return self.esAstuta() or self.esExtraordinaria()
 }
 method poderOfensivo() {
  return (poderMagico * 10) + rol.poderExtra()
 }
}


class Mascota {
  const property tieneCuernos
  const edad
  
  method edad() {
    return edad
  }
  method esVeterana() {
    return edad >= 10
  }
}


class Duende inherits Criatura{
  override method poderOfensivo() {
    return super() * 1.1
  }
  override method esAstuta() {
    return false
  }
  override method esExtraordinaria() {
    return rol.extraordinario(self)
  }
}


class Hada inherits Criatura{
  var kilometrosAVolar = 2

  method cambiarKilometros() = 0

  override method esAstuta() {
    return astucia > 50
  }
  override method esExtraordinaria() {
    return rol.extraordinario(self) && kilometrosAVolar > 10
  }
}


object guardian {
  method poderExtra() {
    return 100
  }
  method extraordinario(criatura) {
    return criatura.poderMagico() > 50
  }
  method nuevoRolPorRitual() {
    return new Domador(mascotas=[new Mascota(edad = 1, tieneCuernos = false)])
  }
}

class Domador {
  const mascotas = []
  method tieneMascotas() = !mascotas.isEmpty()
  method tieneCuernos(unaMascota) = mascotas.contains(unaMascota) and unaMascota.tieneCuernos()
  method edadDeLaMascota(unaMascota) {
    if(mascotas.contains(unaMascota)) {
      return unaMascota.edad()
    }
    return 0
  }
  method poderExtra() {
   return mascotas.count({m => self.tieneCuernos(m)}) * 150
  }
  method extraordinario(criatura) {
    return criatura.poderMagico() >= 15 && mascotas.all({m => m.esVeterana()})
  }
  method alMenosUnaMascotaConCuernos() {
    return mascotas.any({m => m.tieneCuernos()})
  }
  method nuevoRolPorRitual() {
    if(!self.alMenosUnaMascotaConCuernos()) {
      self.error("No puede cambiar...")
    }
    return hechicero
  }
}


object hechicero {
  method poderExtra() {
    return 0
  }
  method extraordinario(criatura) {
    return true
  }
  method nuevoRolPorRitual() {
    return guardian
  }
}


class Colonia {
  const criaturas = []

  method poderOfensivo() {
    return criaturas.sum({c => c.poderOfensivo()})
  }
  method cantidadDeCriaturasFormidables() {
    return criaturas.count({c => c.esFormidable()})
  }
  method atacarA(unArea) {
    if(self.poderOfensivo() > unArea.poderDefensivo()) {
      unArea.esUsurpada(self)
    } else {
      criaturas.forEach({c => c.perder15DePoder()})
    }
  }
}


class Area {
  var colonia = new Colonia(criaturas = [])
  method poderDefensivo()
  method esUsurpada(unaColonia) {
    colonia = unaColonia
  }
}


class Castillo inherits Area{
  override method poderDefensivo() {
    return 200 * colonia.cantidadDeCriaturasFormidables()
  }
}


class Claro inherits Area {
  override method poderDefensivo() {
    return 100 + colonia.poderOfensivo()
  }
}