class Factura {
  final int idFactura;
  final String fechaEmision;
  final double montoBase;
  final double impuesto;
  final double total;
  final String estado;
  final List<DetalleFactura> detalles;

  Factura({
    required this.idFactura,
    required this.fechaEmision,
    required this.montoBase,
    required this.impuesto,
    required this.total,
    required this.estado,
    required this.detalles,
  });

  factory Factura.fromJson(Map<String, dynamic> json) {
    return Factura(
      idFactura: json["iD_Factura"],
      fechaEmision: json["fecha_Emision"],
      montoBase: (json["monto_Base"] ?? 0).toDouble(),
      impuesto: (json["impuesto"] ?? 0).toDouble(),
      total: (json["total"] ?? 0).toDouble(),
      estado: json["estado"] ?? "",
      detalles: (json["detalles"] as List)
          .map((d) => DetalleFactura.fromJson(d))
          .toList(),
    );
  }
}

class DetalleFactura {
  final int idDetalle;
  final int idFactura;
  final String descripcion;
  final double monto;
  final String? detalle;

  DetalleFactura({
    required this.idDetalle,
    required this.idFactura,
    required this.descripcion,
    required this.monto,
    this.detalle,
  });

  factory DetalleFactura.fromJson(Map<String, dynamic> json) {
    return DetalleFactura(
      idDetalle: json["iD_Detalle"],
      idFactura: json["iD_Factura"],
      descripcion: json["descripcion"] ?? "",
      monto: (json["monto"] ?? 0).toDouble(),
      detalle: json["detalle"],
    );
  }
}
