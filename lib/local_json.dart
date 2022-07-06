import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jsons/model/araba_model.dart';

class LocalJson extends StatefulWidget {
  const LocalJson({super.key});

  @override
  State<LocalJson> createState() => _LocalJsonState();
}

class _LocalJsonState extends State<LocalJson> {
  String _title = 'Local json işlemleri';

  late final Future<List<Araba>> _listeyiDoldur;

  @override
  void initState() {
    super.initState();
    _listeyiDoldur = arabalarJsonOku();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      floatingActionButton: FloatingActionButton(onPressed: () {
        setState(() {
          _title = "Buton tıklandı";
        });
      }),
      body: FutureBuilder<List<Araba>>(
          future: arabalarJsonOku(),
          initialData: [
            Araba(
                arabaAdi: 'AAA',
                kurulusYili: 1988,
                ulke: 'sdfsd',
                model: [Model(modelAdi: 'a', fiyat: 123, benzinli: false)])
          ],
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Araba> arabaListesi = snapshot.data!;
              return ListView.builder(
                itemCount: arabaListesi.length,
                itemBuilder: (context, index) {
                  var oAnkiAraba = arabaListesi[index];
                  return ListTile(
                    title: Text(oAnkiAraba.arabaAdi),
                    subtitle: Text(arabaListesi[index].ulke),
                    leading: CircleAvatar(
                        child: Text(
                            arabaListesi[index].model[0].fiyat.toString())),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  Future<List<Araba>> arabalarJsonOku() async {
    try {
      // await Future.delayed(const Duration(seconds: 5), () {
      //   return Future.error('5 saniye sonra hata çıktı');
      // });
      debugPrint('5 saniyelik işlem başlıyor');
      await Future.delayed(const Duration(seconds: 5), () {
        debugPrint('5 saniyelik işlem bitti');
      });
      // ignore: use_build_context_synchronously
      String okunanString = await DefaultAssetBundle.of(context)
          .loadString('assets/data/arabalar.json');

      var jsonObject = jsonDecode(okunanString);

      List<Araba> tumArabalar = (jsonObject as List)
          .map((arabaMap) => Araba.fromMap(arabaMap))
          .toList();

      debugPrint(tumArabalar.length.toString());

      return tumArabalar;
    } catch (e) {
      debugPrint(e.toString());
      return Future.error(e.toString());
    }
  }
}
