import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:zs_satis/anbar/model_mehsullar.dart';
import 'package:zs_satis/anbar/model_qrup.dart';
import 'package:zs_satis/anbar/model_stockhereket.dart';
import 'package:zs_satis/musteriler/model_musteriler.dart';
import 'package:zs_satis/satis/model_carihereket.dart';
import 'package:zs_satis/satis/model_satis.dart';

class SqlDatabase {
  String? path;

  SqlDatabase._();

  static final SqlDatabase db = SqlDatabase._();
  Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await init();
    return _database;
  }

  init() async {
    String path = await getDatabasesPath();
    path = join(path, 'UmumiBaza.db');
    return await openDatabase(path, version: 2,
        onCreate: (Database db, int version) async {
          await db.execute(
              'CREATE TABLE Musteriler (id INTEGER PRIMARY KEY, carikod TEXT, musteriadi TEXT, '
                  'mesulsexs TEXT, telefon TEXT, kodrdinatlar TEXT, tamunvan TEXT, qeydiyyattarixi DATETIME,ilkinborc REAL,'
                  ' sonborc REAL, lastupdateday DATETIME,qeyd TEXT);');
          await db.execute(
              'CREATE TABLE AnbarStockMehsul(id INTEGER PRIMARY KEY, mehsulkodu TEXT, anaqrup TEXT, maladi TEXT,'
                  ' createDate DATETIME,vahid TEXT, qitmet REAL, mayadeyeri REAL, qeyd TEXT);');
          await db.execute(
              'CREATE TABLE AnbarStockHereket(id INTEGER PRIMARY KEY ,createDate DATETIME ,herekettipi TEXT, fakturaid TEXT,'
                  ' groupid TEXT, mehsulkodu TEXT, musterikodu TEXT, gisirsayi REAL, cixissayi REAL, sonqaliq REAL,'
                  ' ilkinqaliq REAL,tesdiqlenme BOOL);');
          await db.execute(
              'CREATE TABLE Satis(id INTEGER PRIMARY KEY, fakturakodu TEXT, carikod TEXT, mehsulkodu TEXT, satisvahid REAL,'
                  ' satisnetsumma REAL, satisendirim REAL, satisxeyir REAL, tarix DATETIME,tesdiqlenme BOOL);');
          await db.execute(
              'CREATE TABLE CariHereket(id INTEGER PRIMARY KEY ,createDate DATETIME ,carikod TEXT,fakturakodu TEXT, brutmebleg REAL, endirimmebleg REAL,netsatis REAL, kassa REAL,tesdiqlenme BOOL,herekttipi TEXT);');
          await db.execute(
              'CREATE TABLE AnbarStockAnaqrup(id INTEGER PRIMARY KEY, anaqrup TEXT, qeyd TEXT);');
          });
  }
/////////////////////cari kereket quryleri////////////////
  Future addCariHerekerToDb(ModelCariHereket carihereket) async {
    final db = await database;
    await db!.transaction((txn) async {
      int id = await txn.rawInsert(
          'INSERT INTO CariHereket(createDate, carikod, fakturakodu, brutmebleg, endirimmebleg, netsatis, kassa, tesdiqlenme, herekttipi) '
              'VALUES("${carihereket.createDate}", "${carihereket
              .carikod}", "${carihereket.fakturakodu}",'
              ' "${carihereket.brutmebleg}", "${carihereket
              .endirimmebleg}", "${carihereket.netsatis}","${carihereket.kassa}", "${carihereket
              .tesdiqleme}", "${carihereket.herekttipi}")');
      if (id > 0) {
        print(
            carihereket.carikod.toString() + " mal sisteme daxil edildi");
      }
    });
  }
  Future<List<ModelSatis>> getAllSatisHereket() async {
    final db = await database;
    List<ModelSatis> listsatis = [];
    List<Map> names = await db!.rawQuery('select * from Satis order by tarix DESC');
    if (names.isNotEmpty) {
      for (var map in names) {
        print(map.toString());
        ModelSatis modelStockHereket=ModelSatis(
          id: map['id'],
          fakturanomresi: map['fakturakodu'],
          mustericarikodu: map['carikod'],
          mehsulkodu: map['mehsulkodu'],
          satismiqdari: map['satisvahid'],
          netsatis: double.tryParse(map['satisnetsumma'].toString()),
          satisendirim: double.tryParse(map['satisendirim'].toString()),
         // tesdiqleme: bool.fromEnvironment(map['tesdiqlenme'],defaultValue: false),
          tesdiqleme: false,
          satisxeyir: double.tryParse(map['satisxeyir'].toString()),
          vaxt: DateTime.tryParse(map['tarix']),);
        listsatis.add(modelStockHereket);
      }
    }
    return listsatis;
  }
  Future<List<ModelCariHereket>> getAllCariHereket() async {
    final db = await database;
    List<ModelCariHereket> mallarlisti = [];
    List<Map> names = await db!.rawQuery('select * from CariHereket order by createDate DESC');
    if (names.isNotEmpty) {
      for (var map in names) {
        print(map.toString());
        ModelCariHereket modelStockHereket=ModelCariHereket(
          id: map['id'],
          carikod: map['carikod'],
          fakturakodu: map['fakturakodu'],
          brutmebleg: map['brutmebleg'],
          endirimmebleg: map['endirimmebleg'],
          netsatis: map['netsatis'],
          kassa: map['kassa'],
          tesdiqleme: bool.fromEnvironment(map['tesdiqlenme']),
          herekttipi: map['herekttipi'],
          createDate: DateTime.tryParse(map['createDate']),);
        mallarlisti.add(modelStockHereket);
      }
    }
    return mallarlisti;
  }
  Future<List<ModelCariHereket>> getAllCariHereketByDay(String deyer) async {
    final db = await database;
    List<ModelCariHereket> mallarlisti = [];
    List<Map> names=[];
      names = await db!.rawQuery('select * from CariHereket where  strftime("%d", CariHereket.createDate) = ?',[deyer]);

    print(names.toString());

    if (names.isNotEmpty) {
      for (var map in names) {
        print(map.toString());
        ModelCariHereket modelStockHereket=ModelCariHereket(
          id: map['id'],
          carikod: map['carikod'],
          fakturakodu: map['fakturakodu'],
          brutmebleg: map['brutmebleg'],
          endirimmebleg: map['endirimmebleg'],
          netsatis: map['netsatis'],
          kassa: map['kassa'],
          tesdiqleme: bool.fromEnvironment(map['tesdiqlenme']),
          herekttipi: map['herekttipi'],
          createDate: DateTime.tryParse(map['createDate']),);
        mallarlisti.add(modelStockHereket);
      }
    }
    return mallarlisti;
  }
  Future<List<ModelCariHereket>> getAllCariHereketByAy(String deyer) async {
    final db = await database;
    print("gelen :"+deyer.toString());
    List<ModelCariHereket> mallarlisti = [];
    List<Map> names=[];
      names = await db!.rawQuery('select * from CariHereket where  strftime("%m", CariHereket.createDate) = ?',[deyer]);
    print(names.toString());

    if (names.isNotEmpty) {
      for (var map in names) {
        ModelCariHereket modelStockHereket=ModelCariHereket(
          id: map['id'],
          carikod: map['carikod'],
          fakturakodu: map['fakturakodu'],
          brutmebleg: map['brutmebleg'],
          endirimmebleg: map['endirimmebleg'],
          netsatis: map['netsatis'],
          kassa: map['kassa'],
          tesdiqleme: bool.fromEnvironment(map['tesdiqlenme']),
          herekttipi: map['herekttipi'],
          createDate: DateTime.tryParse(map['createDate']),);
        mallarlisti.add(modelStockHereket);
      }
    }
    return mallarlisti;
  }
  Future<List<ModelCariHereket>> getAllCariHereketBySonHefte(DateTime ilkgun,DateTime songun) async {
    final db = await database;
    List<ModelCariHereket> mallarlisti = [];
   List<Map> names = await db!.rawQuery('select * from CariHereket where  createDate >= ? and createDate <= ?',['$ilkgun','$songun']);
    if (names.isNotEmpty) {
      for (var map in names) {
        ModelCariHereket modelStockHereket=ModelCariHereket(
          id: map['id'],
          carikod: map['carikod'],
          fakturakodu: map['fakturakodu'],
          brutmebleg: map['brutmebleg'],
          endirimmebleg: map['endirimmebleg'],
          netsatis: map['netsatis'],
          kassa: map['kassa'],
          tesdiqleme: bool.fromEnvironment(map['tesdiqlenme']),
          herekttipi: map['herekttipi'],
          createDate: DateTime.tryParse(map['createDate']),);
        mallarlisti.add(modelStockHereket);
      }
    }
    return mallarlisti;
  }
////////////////////////////////////////////////////////////


//////////////////////SatisHereket ////////////////////////
  Future<int?> getLasFakturaId() async {
    final db = await database;
    List<Map> maps = [];
    maps = await db!.query('Satis', orderBy: "id DESC", limit: 1, columns: [
      'id',
    ]);
    if (maps.isNotEmpty) {
      return (int.parse(maps[0]['id'].toString()) + 1);
    } else {
      return 1;
    }
  }

  Future addSatisToDb(ModelSatis modelSatis) async {
    final db = await database;
    await db!.transaction((txn) async {
      int id = await txn.rawInsert(
          'INSERT INTO Satis(fakturakodu, carikod, mehsulkodu, satisvahid, satisnetsumma, satisendirim, satisxeyir, tarix) '
              'VALUES("${modelSatis.fakturanomresi}", "${modelSatis
              .mustericarikodu}", "${modelSatis.mehsulkodu}",'
              ' "${modelSatis.satismiqdari}", "${modelSatis
              .satissumma}", "${modelSatis.satisendirim}", "${modelSatis
              .satisxeyir}", "${modelSatis.vaxt}")');
      if (id > 0) {
        print(
            modelSatis.fakturanomresi.toString() + " mal sisteme daxil edildi");
      }
    });
  }

  Future<int> updateMusteriSatisData(double ilkinqaliq, double sonqaliq) async {
    var nov=DateTime.now();
    final db = await database;
    return await db!.rawUpdate('''
    UPDATE Musteriler
    SET  ilkinborc = ?, sonborc = ?, lastupdateday = ?
    WHERE anaqrup = ?
    ''', [ilkinqaliq, sonqaliq, nov]);
  }
  ///////////////////////////////////////////////////////////////////////////////


  getAllRecord() async {
    final db = await database;
    List<Map> names = await db!.rawQuery('select AnbarStockMehsul.maladi, AnbarStockHereket.sonqaliq  from AnbarStockMehsul, AnbarStockHereket where AnbarStockMehsul.mehsulkodu=AnbarStockHereket.mehsulkodu');

    print("names :" + names.toString());
    if (names.length > 0) {
      return names;
    }
    return null;
  }

//
//   /////////////////UserEmeliyyatlar/////////////////////////////
//   Future<ModelUser> addNewUserToDB(ModelUser newuser) async {
//     final db = await database;
//     await db!.transaction((txn) async {
//       int id = await txn.rawInsert(
//           'INSERT INTO Users(userid, username, userphone, usersirket, usersirketsoapadress) '
//           'VALUES("${newuser.userId}", "${newuser.userName}","${newuser.userPhone}","${newuser.userSirket}","${newuser.usersirketsoapadress}")');
//       // int id = await txn.rawInsert(
//       //         'INSERT INTO Istifadeciler(userid, username, userphone, usersirket,usersirketsoapadress,'
//       //             'usersirketsoaphost,userregion,usersobe,uservezife,usertemsilcikodu,usermaliyyebaglanti,'
//       //             'usercrmbaglanti,userbmbaglanti,userstbaglanti,userlisenziya,userizlemegiris,'
//       //             'userizlemefull,useryetkiler) VALUES("${newuser.userid}", "${newuser.username}","${newuser.userphone}",'
//       //             '"${newuser.usersirket}","${newuser.usersirketsoapadress},"${newuser.usersirketsoaphost}",'
//       //             '"${newuser.userregion}","${newuser.usersobe},"${newuser.uservezife}","${newuser.usertemsilcikodu}"'
//       //             ',"${newuser.usermaliyyebaglanti},"${newuser.usercrmbaglanti}","${newuser.userbmbaglanti}",'
//       //             '"${newuser.userstbaglanti},"${newuser.userlisenziya}","${newuser.userizlemegiris}","${newuser.userizlemefull},"${newuser.useryetkiler}")');
//
//       if (id > 0) {
//         print(newuser.userId.toString() + " sisteme daxil edildi");
//       }
//     });
//     return newuser;
//   }
//
// ///////////////////Cari Emeliyyatlar////////////////////////////
//   Future<List<ModelCariler>> getCarilerFromDB() async {
//     final db = await database;
//     List<ModelCariler> notesList = [];
//     List<Map> maps = await db!.query('Cariler', columns: [
//       'carikod',
//       'cariad',
//       'rayon',
//       'h1',
//       'anacari',
//       'tem',
//       'tamun',
//       'mesulsexs',
//       'voun',
//       'telefon',
//       'sticker',
//       'sahe',
//       'kateq',
//       'bolgekodu',
//       'qaliq',
//       'gpsuzunluq',
//       'gpseynilik',
//       'gbir',
//       'giki',
//       'guc',
//       'gdort',
//       'gbes',
//       'galti',
//       'gbazar',
//       'girisedildi'
//     ]);
//     if (maps.isNotEmpty) {
//       for (var map in maps) {
//         notesList.add(ModelCariler.fromJson(map));
//       }
//     }
//     return notesList;
//   }
//
//   Future<ModelCariler?> getGirisEdilmisByCkodFromDB() async {
//     final db = await database;
//     List<Map> maps = await db!.query('Cariler',
//         where: 'girisedildi = ?', whereArgs: [
//         '1'],
//         columns: [
//       'carikod',
//       'cariad',
//       'rayon',
//       'h1',
//       'anacari',
//       'tem',
//       'tamun',
//       'mesulsexs',
//       'voun',
//       'telefon',
//       'sticker',
//       'sahe',
//       'kateq',
//       'bolgekodu',
//       'qaliq',
//       'gpsuzunluq',
//       'gpseynilik',
//       'gbir',
//       'giki',
//       'guc',
//       'gdort',
//       'gbes',
//       'galti',
//       'gbazar',
//       'girisedildi'
//     ]);
//     if(maps.isNotEmpty){
//       return ModelCariler.fromJson(maps.first);
//     }else{
//       print("Melumat Yoxdur");
//     }
//   }
//
//   updateGiris(String ckod, String girisedilme) async {
//     final db = await database;
//     await db!.rawUpdate('''
//     UPDATE Cariler
//     SET  girisedildi = ?
//     WHERE carikod = ?
//     ''',
//         [girisedilme,ckod]);
//   }
//
//   Future<List<ModelCariler>> getCarilerByRutGunuFromDB(String rutgunu) async {
//     final db = await database;
//     List<ModelCariler> notesList = [];
//     List<Map> maps = [];
//     switch (rutgunu) {
//       case "1":
//         maps = await db!.query('Cariler', where: 'gbir = ?', whereArgs: [
//           '1'
//         ], columns: [
//           'carikod',
//           'cariad',
//           'rayon',
//           'h1',
//           'anacari',
//           'tem',
//           'tamun',
//           'mesulsexs',
//           'voun',
//           'telefon',
//           'sticker',
//           'sahe',
//           'kateq',
//           'bolgekodu',
//           'qaliq',
//           'gpsuzunluq',
//           'gpseynilik',
//           'gbir',
//           'giki',
//           'guc',
//           'gdort',
//           'gbes',
//           'galti',
//           'gbazar',
//           'girisedildi'
//         ]);
//         break;
//       case "2":
//         maps = await db!.query('Cariler', where: 'giki = ?', whereArgs: [
//           '1'
//         ],  columns: [
//           'carikod',
//           'cariad',
//           'rayon',
//           'h1',
//           'anacari',
//           'tem',
//           'tamun',
//           'mesulsexs',
//           'voun',
//           'telefon',
//           'sticker',
//           'sahe',
//           'kateq',
//           'bolgekodu',
//           'qaliq',
//           'gpsuzunluq',
//           'gpseynilik',
//           'gbir',
//           'giki',
//           'guc',
//           'gdort',
//           'gbes',
//           'galti',
//           'gbazar',
//           'girisedildi'
//         ]);
//         break;
//       case "3":
//         maps = await db!.query('Cariler', where: 'guc = ?', whereArgs: [
//           '1'
//         ], columns: [
//           'carikod',
//           'cariad',
//           'rayon',
//           'h1',
//           'anacari',
//           'tem',
//           'tamun',
//           'mesulsexs',
//           'voun',
//           'telefon',
//           'sticker',
//           'sahe',
//           'kateq',
//           'bolgekodu',
//           'qaliq',
//           'gpsuzunluq',
//           'gpseynilik',
//           'gbir',
//           'giki',
//           'guc',
//           'gdort',
//           'gbes',
//           'galti',
//           'gbazar',
//           'girisedildi'
//         ]);
//         break;
//       case "4":
//         maps = await db!.query('Cariler', where: 'gdort = ?', whereArgs: [
//           '1'
//         ],  columns: [
//           'carikod',
//           'cariad',
//           'rayon',
//           'h1',
//           'anacari',
//           'tem',
//           'tamun',
//           'mesulsexs',
//           'voun',
//           'telefon',
//           'sticker',
//           'sahe',
//           'kateq',
//           'bolgekodu',
//           'qaliq',
//           'gpsuzunluq',
//           'gpseynilik',
//           'gbir',
//           'giki',
//           'guc',
//           'gdort',
//           'gbes',
//           'galti',
//           'gbazar',
//           'girisedildi'
//         ]);
//         break;
//       case "5":
//         maps = await db!.query('Cariler', where: 'gbes = ?', whereArgs: [
//           '1'
//         ],  columns: [
//           'carikod',
//           'cariad',
//           'rayon',
//           'h1',
//           'anacari',
//           'tem',
//           'tamun',
//           'mesulsexs',
//           'voun',
//           'telefon',
//           'sticker',
//           'sahe',
//           'kateq',
//           'bolgekodu',
//           'qaliq',
//           'gpsuzunluq',
//           'gpseynilik',
//           'gbir',
//           'giki',
//           'guc',
//           'gdort',
//           'gbes',
//           'galti',
//           'gbazar',
//           'girisedildi'
//         ]);
//         break;
//       case "6":
//         maps = await db!.query('Cariler', where: 'galti = ?', whereArgs: [
//           '1'
//         ],  columns: [
//           'carikod',
//           'cariad',
//           'rayon',
//           'h1',
//           'anacari',
//           'tem',
//           'tamun',
//           'mesulsexs',
//           'voun',
//           'telefon',
//           'sticker',
//           'sahe',
//           'kateq',
//           'bolgekodu',
//           'qaliq',
//           'gpsuzunluq',
//           'gpseynilik',
//           'gbir',
//           'giki',
//           'guc',
//           'gdort',
//           'gbes',
//           'galti',
//           'gbazar',
//           'girisedildi'
//         ]);
//         break;
//     }
//
//     if (maps.isNotEmpty) {
//       for (var map in maps) {
//         notesList.add(ModelCariler.fromJson(map));
//       }
//     }
//     return notesList;
//   }
//
//   updateCariInDB(ModelCariler modelCariler) async {
//     final db = await database;
//     await db!.update('Cariler', modelCariler.toMap(),
//         where: 'carikod = ?', whereArgs: [modelCariler.carikod]);
//   }
//
//   deleteCariKodFromUmumiCariler(ModelCariler modelCariler) async {
//     final db = await database;
//     await db!.delete('Cariler',
//         where: 'carikod = ?', whereArgs: [modelCariler.carikod]);
//     print('Note deleted');
//   }
//
//   deleteAllDataFromUmumiCarilerTable() async {
//     final db = await database;
//     await db!.delete("Cariler").whenComplete(() {
//       print("Cariler bazasi silindi");
//     });
//   }
//
//   Future<ModelCariler> addCariToDB(ModelCariler newNote) async {
//     final db = await database;
//     await db!.transaction((txn) async {
//       int id = await txn.rawInsert('INSERT INTO Cariler(carikod, cariad, '
//           'rayon,h1,anacari,girisedildi,'
//           'tem,tamun,mesulsexs,voun,'
//           'telefon,sticker,sahe,kateq,'
//           'bolgekodu,qaliq,gpsuzunluq,gpseynilik,gbir,giki,'
//           'guc,gdort,gbes,galti,gbazar) '
//           'VALUES("${newNote.carikod}", "${newNote.cariad}",'
//           ' "${newNote.rayon}", "${newNote.hereket}", "${newNote.anaCari}", "${"0"}",'
//           ' "${newNote.expkodu}", "${newNote.tamun}", "${newNote.mehsulsexs}", "${newNote.voun}",'
//           ' "${newNote.telefon}", "${newNote.sticker}", "${newNote.sahe}", "${newNote.kateqoriya}",'
//           ' "${newNote.bolgekodu}", "${newNote.qaliq}", "${newNote.gpsuzunluq}", "${newNote.gpseynilik}", "${newNote.gbir}", "${newNote.giki}",'
//           ' "${newNote.guc}", "${newNote.gdort}", "${newNote.gbes}", "${newNote.galti}", "${newNote.gbagli}")');
//       if (id > 0) {
//         print(newNote.cariad.toString() + " sisteme daxil edildi");
//       }
//     });
//     return newNote;
//   }
//
// /////////////////////////////////GirisCixis//////////////////////////
//   Future<ModelGirisCixis> insertNewGirisCixis(ModelGirisCixis newNote) async {
//     final db = await database;
//     await db!.transaction((txn) async {
//       int id = await txn.rawInsert('INSERT INTO Girisler(ckod, cariad, '
//           'girisvaxt,girisvaxtfirebase,cixisvaxt,girisgps,'
//           'cixisgps,temsilcikodu,qeyd,girismesafe,'
//           'cixismesafe,rutgunu,tarix,vezife_id,temsilciadi,dukankonum,gonderilme) '
//           'VALUES("${newNote.ckod}", "${newNote.cariad}",'
//           ' "${newNote.girisvaxt}", "${newNote.girisvaxtfirebase}", "${newNote.cixisvaxt}", "${newNote.girisgps}",'
//           ' "${newNote.cixisgps}", "${newNote.temsilcikodu}", "${newNote.qeyd}", "${newNote.girismesafe}",'
//           ' "${newNote.cixismesafe}", "${newNote.rutgunu}", "${newNote.tarix}", "${newNote.vezife_id}", "${newNote.temsilciadi}", "${newNote.dukankonum}", "${newNote.gonderilme}")');
//       if (id > 0) {
//         print(newNote.cariad.toString() + " sisteme daxil edildi");
//       }
//     });
//     return newNote;
//   }
//
//   Future<List<ModelGirisCixis>> getAllGirisCixis() async {
//     final db = await database;
//     List<ModelGirisCixis> notesList = [];
//     List<Map> maps = await db!.query('Girisler', columns: [
//       'ckod',
//       'cariad',
//       'girisvaxt',
//       'girisvaxtfirebase',
//       'cixisvaxt',
//       'girisgps',
//       'cixisgps',
//       'temsilcikodu',
//       'girismesafe',
//       'cixismesafe',
//       'rutgunu',
//       'tarix',
//       'vezife_id',
//       'temsilciadi',
//       'dukankonum',
//       'gonderilme',
//     ]);
//     if (maps.isNotEmpty) {
//       for (var map in maps) {
//         notesList.add(ModelGirisCixis.fromJson(map));
//       }
//     }
//     return notesList;
//   }
//
//   Future<List<ModelGirisCixis>> getCixisEdilmeyen() async {
//     final db = await database;
//     late ModelGirisCixis modelGirisCixis;
//     List<ModelGirisCixis> listModeller=[];
//     List<Map> maps =
//         await db!.query('Girisler', where: 'cixisgps = ?', whereArgs: [
//       'bos'
//     ], columns: [
//       'ckod',
//       'cariad',
//       'girisvaxt',
//       'girisvaxtfirebase',
//       'cixisvaxt',
//       'girisgps',
//       'cixisgps',
//       'temsilcikodu',
//       'girismesafe',
//       'cixismesafe',
//       'rutgunu',
//       'tarix',
//       'vezife_id',
//       'temsilciadi',
//       'dukankonum',
//       'gonderilme',
//     ]);
//     if (maps.isNotEmpty) {
//       for (var map in maps) {
//         modelGirisCixis = ModelGirisCixis.fromJson(map);
//         listModeller.add(modelGirisCixis);
//       }
//     }
//     return listModeller;
//   }
//
//   Future<int> updateGirisCixisCixisEdildi(ModelGirisCixis model) async {
//     final db = await database;
//     String columnId = 'ckod';
//     return await db!.update("Girisler", model.toMap(),
//         where: '$columnId = ?', whereArgs: [model.ckod]);
//   }
//
//   updateGirisCixisServereGonderildi(String ckod, String gonderilme) async {
//     final db = await database;
//     int updateCount = await db!.rawUpdate('''
//     UPDATE Cariler
//     SET ckod = ?
//     WHERE gonderilme = ?
//     ''', [ckod, gonderilme]);
//   }
//
//   deleteAllDataFromGirisCixislarTable() async {
//     final db = await database;
//     await db!.delete("Girisler").whenComplete(() {
//       print("Cariler bazasi silindi");
//     });
//   }

///////////////////////////////Anbar Raporlari///////////////////////
  deleteAllDatabaseAnbar() async {
    final db = await database;
    await db!.delete("AnbarRapor").whenComplete(() {
      print("AnbarRapor bazasi silindi");
    });
  }

  deleteMehsulByName(ModelMehsullar modelCariler) async {
    final db = await database;
    await db!.delete('AnbarStockMehsul',
        where: 'maladi = ?', whereArgs: [modelCariler.malinAdi]);
    print('Note deleted');
  }

  Future<int> deleteQrupadiByName(String qrupadi) async {
    final db = await database;
    return await db!.delete('AnbarStockAnaqrup',
        where: 'anaqrup = ?', whereArgs: [qrupadi.toString()]);
  }

  Future<int> deleteMusteriByCkod(String ckod) async {
    final db = await database;
    return await db!.delete('Musteriler',
        where: 'carikod = ?', whereArgs: [ckod.toString()]);
  }

  Future addAnbarMehsulToDb(ModelMehsullar modelAnbar) async {
    final db = await database;
    await db!.transaction((txn) async {
      int id = await txn.rawInsert(
          'INSERT INTO AnbarStockMehsul(anaqrup, maladi, mehsulkodu, createDate, vahid,qitmet, mayadeyeri ,qeyd) '
              'VALUES("${modelAnbar.qrupAdi}", "${modelAnbar
              .malinAdi}", "${modelAnbar.mehsulkodu}",'
              ' "${modelAnbar.createDate}", "${modelAnbar
              .malVahid}", "${modelAnbar.malinQitmeti}",  "${modelAnbar
              .mayaDeyeri}", "${modelAnbar.malinHaqqinda}")');
      if (id > 0) {
        print(modelAnbar.malinAdi.toString() + " mal sisteme daxil edildi");
      }
    });
  }

  Future addStockHerekerToDb(ModelStockHereket modelSatis) async {
    final db = await database;
    await db!.transaction((txn) async {
      int id = await txn.rawInsert(
          'INSERT INTO AnbarStockHereket(createDate, herekettipi, groupid, mehsulkodu, musterikodu, gisirsayi, cixissayi, sonqaliq, ilkinqaliq, tesdiqlenme ) '
              'VALUES("${modelSatis.createDate}", "${modelSatis
              .herekettipi}", "${modelSatis.groupid}", "${modelSatis.mehsulkodu}",'
              ' "${modelSatis.musterikodu}", "${modelSatis
              .gisirsayi}", "${modelSatis.cixissayi}","${modelSatis.sonqaliq}", "${modelSatis
              .ilkinqaliq}", "${modelSatis.tesdiqlenme}")');
      if (id > 0) {
        print(modelSatis.mehsulkodu.toString() + " mal sisteme daxil edildi");
      }
    });
  }

  Future addMusteritoDb(ModelMusteriler modelMusteriler) async {
    final db = await database;
    await db!.transaction((txn) async {
      int id = await txn.rawInsert(
          'INSERT INTO Musteriler(carikod,musteriadi, mesulsexs, telefon, kodrdinatlar, tamunvan, '
              'qeydiyyattarixi, ilkinborc, sonborc, lastupdateday ,qeyd) '
              'VALUES("${modelMusteriler.carikod}","${modelMusteriler
              .musteriadi}", "${modelMusteriler.mesulsexs}",'
              ' "${modelMusteriler.telefon}", "${modelMusteriler
              .kodrdinatlar}", "${modelMusteriler
              .tamunvan}", "${modelMusteriler.qeydiyyattarixi}", "${0}", "${0}", "${modelMusteriler
              .qeydiyyattarixi}", "${modelMusteriler.qeyd}")');
      if (id > 0) {
        print(modelMusteriler.musteriadi.toString() +
            " mal sisteme daxil edildi");
      }
    });
  }

  Future addAnbarQrupToDb(ModelQrupadi modelAnbar) async {
    final db = await database;
    await db!.transaction((txn) async {
      int id =
      await txn.rawInsert('INSERT INTO AnbarStockAnaqrup(anaqrup, qeyd) '
          'VALUES("${modelAnbar.qrupAdi}", "${modelAnbar.qruphaqqinda}")');
      if (id > 0) {
        print(modelAnbar.qrupAdi.toString() + " mal sisteme daxil edildi");
      }
    });
  }

  Future<int> updateAnaQrupName(ModelQrupadi model, String kohneqrup) async {
    final db = await database;
    return await db!.rawUpdate('''
    UPDATE AnbarStockAnaqrup
    SET  anaqrup = ?, qeyd = ?
    WHERE anaqrup = ?
    ''', [model.qrupAdi, model.qruphaqqinda, kohneqrup]);
  }

  updateAnaQrupNameinMehsullar(String kohneQrupadi, String yeniqrup) async {
    final db = await database;
    await db!.rawUpdate('''
    UPDATE AnbarStockMehsul
    SET  anaqrup = ?
    WHERE anaqrup = ?
    ''', [yeniqrup, kohneQrupadi]);
  }

  Future<List<ModelMehsullar>> getAllMallarByAnaQrup(String anaqrup) async {
    final db = await database;
    List<ModelMehsullar> mallarlisti = [];
    List<Map> maps =
    await db!.query('AnbarStockMehsul', where: 'anaqrup = ?', whereArgs: [
      anaqrup
    ], columns: [
      'id',
      'mehsulkodu',
      'anaqrup',
      'maladi',
      'createDate',
      'vahid',
      'qitmet',
      'mayadeyeri',
      'qeyd'
    ]);
    if (maps.isNotEmpty) {
      for (var map in maps) {
        double malinsayi=0;
        List<Map> mapsa = await db.query('AnbarStockHereket',
            orderBy: "id DESC",
            limit: 1,
            whereArgs:  [map['mehsulkodu']],
            where: "mehsulkodu = ?",
            columns: [
              'sonqaliq'
            ]);
        if (mapsa.isNotEmpty) {
          for(var t in mapsa){
            malinsayi=malinsayi + t['sonqaliq'];
          }
        }else{
          malinsayi=0;
        }
        ModelMehsullar modelAnbarRapor = ModelMehsullar(
          malinSayi: malinsayi,
          id: map['id'],
          mehsulkodu: map['mehsulkodu'],
          malVahid: map['vahid'],
          qrupAdi: map['anaqrup'],
          malinAdi: map['maladi'],
          malinHaqqinda: map['qeyd'],
          createDate: DateTime.tryParse(map['createDate']),
          malinQitmeti: map['qitmet'],
          mayaDeyeri: map['mayadeyeri'],
        );
        mallarlisti.add(modelAnbarRapor);

      }
    }
    return mallarlisti;
  }

  Future<List<ModelMehsullar>> getAllMallar() async {
    final db = await database;
    List<ModelMehsullar> mallarlisti = [];
    List<Map> maps = await db!.query('AnbarStockMehsul', columns: [
      'id',
      'mehsulkodu',
      'anaqrup',
      'maladi',
      'createDate',
      'vahid',
      'qitmet',
      'mayadeyeri',
      'qeyd'
    ]);
    if (maps.isNotEmpty) {
      for (var map in maps) {
        double malinsayi=0;
        List<Map> mapa = await db.query('AnbarStockHereket',
            where: "mehsulkodu = ?",
            whereArgs: [map['mehsulkodu']],
            orderBy: "id DESC",
            limit: 1,
            columns: [
          'sonqaliq',
        ]);
        if(mapa.isNotEmpty){
          malinsayi=mapa[0]["sonqaliq"];
        }

        ModelMehsullar modelAnbarRapor = ModelMehsullar(
          id: map['id'],
          malVahid: map['vahid'],
          mehsulkodu: map['mehsulkodu'],
          qrupAdi: map['anaqrup'],
          malinAdi: map['maladi'],
          malinHaqqinda: map['qeyd'],
          mayaDeyeri: map['mayadeyeri'],
          createDate: DateTime.tryParse(map['createDate']),
          malinQitmeti: map['qitmet'],
          malinSayi: malinsayi
        );
        mallarlisti.add(modelAnbarRapor);
      }
    }
    return mallarlisti;
  }

  Future<List<ModelStockHereket>> getAllStockHereket() async {
    final db = await database;
    List<ModelStockHereket> mallarlisti = [];
    List<Map> names = await db!.rawQuery('select * from AnbarStockHereket order by createDate DESC');
    if (names.isNotEmpty) {
      for (var map in names) {
    ModelStockHereket modelStockHereket=ModelStockHereket(
    sonqaliq: map['sonqaliq'],
    herekettipi: map['herekettipi'],
    groupid: map['groupid'],
    mehsulkodu: map['mehsulkodu'],
    musterikodu: map['musterikodu'],
    gisirsayi: map['gisirsayi'],
    cixissayi: map['cixissayi'],
    ilkinqaliq: map['ilkinqaliq'],
    tesdiqlenme: bool.fromEnvironment(map['tesdiqlenme']),
    createDate: DateTime.tryParse(map['createDate']),);
        mallarlisti.add(modelStockHereket);
      }
    }
    return mallarlisti;
  }

  Future<ModelSenedTotal> getAllMehsulRapor() async {
    double totalehtiyyat=0;
    double totalmalsayi=0;
    final db = await database;
    ModelSenedTotal modelSenedTotal;
    List<ModelMehsullar> mallarlisti = [];
    double sumsatis = 0;
    double sumendirim = 0;
    List<Map> maps = await db!.query('AnbarStockMehsul', columns: [
      'id',
      'mehsulkodu',
      'anaqrup',
      'maladi',
      'createDate',
      'vahid',
      'qitmet',
      'mayadeyeri',
      'qeyd'
    ]);
    if (maps.isNotEmpty) {
      for (var map in maps) {
        List<Map> maprapor = [];
        maprapor = await db.query('AnbarStockHereket',
            where: "mehsulkodu = ?",
            whereArgs: [map['mehsulkodu']],
            orderBy: "id DESC",
            columns: [
              'sonqaliq',
            ]);
        if(maprapor.isNotEmpty){
          totalmalsayi= maprapor[0]['sonqaliq'];
          totalehtiyyat=totalehtiyyat+maprapor[0]['sonqaliq'];
        }
        ModelMehsullar modelAnbarRapor = ModelMehsullar(
          id: map['id'],
          malVahid: map['vahid'],
          malinSayi: totalmalsayi,
          mehsulkodu: map['mehsulkodu'],
          qrupAdi: map['anaqrup'],
          malinAdi: map['maladi'],
          malinHaqqinda: map['qeyd'],
          mayaDeyeri: map['mayadeyeri'],
          createDate: DateTime.tryParse(map['createDate']),
          malinQitmeti: map['qitmet'],
        );
        mallarlisti.add(modelAnbarRapor);
        final countsay = await db.rawQuery("SELECT COUNT(mehsulkodu) FROM Satis WHERE mehsulkodu = ?", [map['mehsulkodu']]);
        bool isExist = countsay[0]["COUNT(mehsulkodu)"] != null;
        if (isExist) {
          sumendirim = double.parse(countsay[0]["COUNT(mehsulkodu)"].toString().replaceAll(".0", ""));
        } else {
          sumsatis = 0;
          sumendirim = 0;
        }
      }
    }
    modelSenedTotal = ModelSenedTotal(
        listMehsullar: mallarlisti,
        totalehtiyyat: totalehtiyyat,
        totalsumma: sumendirim);
    return modelSenedTotal;
  }

  Future<List<ModelMusteriler>> getAllMusteriler() async {
    final db = await database;
    List<ModelMusteriler> mallarlisti = [];
    List<Map> maps = await db!.query('Musteriler', columns: [
      'id',
      'carikod',
      'musteriadi',
      'mesulsexs',
      'telefon',
      'kodrdinatlar',
      'tamunvan',
      'qeydiyyattarixi',
      'qeyd',
      'ilkinborc',
      'sonborc',
      'lastupdateday',
    ]);

    if (maps.isNotEmpty) {
      for (var map in maps) {
        double sumsatis = 0;
        double sumendirim = 0;
        double sumxeyir = 0;
        double netsatis = 0;
        double netkassa = 0;
        double sonqaliq = 0;
        final sumSatis = await db.rawQuery("SELECT SUM(satisnetsumma) FROM Satis WHERE carikod = ?", [map['carikod']]);
        final sumEndirim = await db.rawQuery("SELECT SUM(satisendirim) FROM Satis WHERE carikod = ?", [map['carikod']]);
        final sumXeyir = await db.rawQuery("SELECT SUM(satisxeyir) FROM Satis WHERE carikod = ?", [map['carikod']]);
        final netsummahereket = await db.rawQuery("SELECT SUM(netsatis) FROM CariHereket where carikod = ?", [map['carikod']]);
        final netkassahereket = await db.rawQuery("SELECT SUM(kassa) FROM CariHereket where carikod = ?", [map['carikod']]);
        bool isExist = sumSatis[0]["SUM(satisnetsumma)"] != null;
        if (isExist) {
          sumsatis = double.parse(sumSatis[0]["SUM(satisnetsumma)"].toString().replaceAll(".0", ""));
          sumendirim = double.parse(sumEndirim[0]["SUM(satisendirim)"].toString().replaceAll(".0", ""));
          sumxeyir = double.parse(sumXeyir[0]["SUM(satisxeyir)"].toString().replaceAll(".0", ""));
          netsatis = double.parse(netsummahereket[0]["SUM(netsatis)"].toString().replaceAll(".0", ""));
          netkassa = double.parse(netkassahereket[0]["SUM(kassa)"].toString().replaceAll(".0", ""));
          sonqaliq=netsatis-netkassa;
        } else {
          sumsatis = 0;
          sumendirim = 0;
          sumxeyir = 0;
        }
        ModelMusteriler modelAnbarRapor = ModelMusteriler(
            sonborc: sonqaliq,
            ilkinborc:map['ilkinborc'] ,
            isclecked: false,
            id: map['id'],
            carikod: map['carikod'],
            mesulsexs: map['mesulsexs'],
            musteriadi: map['musteriadi'],
            telefon: map['telefon'],
            kodrdinatlar: map['kodrdinatlar'],
            tamunvan: map['tamunvan'],
            qeydiyyattarixi: DateTime.parse(map['qeydiyyattarixi']),
            lastupdateday: DateTime.parse(map['qeydiyyattarixi']),
            qeyd: map['qeyd'],
            umumisatis: sumsatis,
            umumixeyir: sumxeyir,
            umumiendirim: sumendirim
          //malinQitmeti: map['qitmet'],
        );
        mallarlisti.add(modelAnbarRapor);
      }
    }
    return mallarlisti;
  }

  Future<List<ModelQrupadi>> getAllAnaQruplar() async {
    List<ModelQrupadi> list_anaqrup = [];
    final db = await database;
    List<Map> maps = [];
    maps = await db!.query('AnbarStockAnaqrup', columns: [
      'id',
      'anaqrup',
      'qeyd',
    ]);
    if (maps.isNotEmpty) {
      for (var map in maps) {
        int totalmalsayi=0;
        List<Map> maprapor = [];
        maprapor = await db.query('AnbarStockHereket',
            groupBy: 'mehsulkodu',
            where: "groupid = ?",
            whereArgs: [map['id']],
            orderBy: "id DESC",
            columns: [
              'sonqaliq',
            ]);
        if(maprapor.isNotEmpty){
          for(var t in maprapor){
            totalmalsayi = totalmalsayi+int.parse(t['sonqaliq'].toString().replaceAll(".0", ""));
          }
        }
        final countmehsul = Sqflite.firstIntValue(await db.rawQuery(
            'SELECT COUNT(anaqrup) FROM AnbarStockMehsul  WHERE anaqrup=?',
            [map['id']]));
        ModelQrupadi model = ModelQrupadi(
          id:  map['id'],
          qrupAdi: map['anaqrup'],
          qruphaqqinda: map['qeyd'],
          cesidSayi: countmehsul,
          mehsulsayi: totalmalsayi,
        );
        list_anaqrup.add(model);
      }
    }

    return list_anaqrup;
  }

  Future<ModelQrupadi> getAllAnaQruplarUmumiCesidler(String grupadi, String qrupqeyd) async {
    final db = await database;
    final sum = await db!.rawQuery("SELECT SUM(qaliq) FROM AnbarStockMehsul");
    bool isExist = sum[0]["SUM(qaliq)"] != null;
    int value = 0;
    if (isExist) {
      value = int.parse(sum[0]["SUM(qaliq)"].toString().replaceAll(".0", ""));
    } else {
      value = 0;
    }
    final countmehsul = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(anaqrup) FROM AnbarStockMehsul'));
    ModelQrupadi model = ModelQrupadi(
        qrupAdi: grupadi,
        qruphaqqinda: qrupqeyd,
        cesidSayi: countmehsul,
        mehsulsayi: value);

    return model;
  }

  Future<int?> getMalCountByAnaqrup(String anaqrup) async {
    //database connection
    final db = await database;
    final count = Sqflite.firstIntValue(await db!.rawQuery(
        'SELECT COUNT(*) FROM AnbarRapor  WHERE anaqrup=?', [anaqrup]));
    // assert(count == 2);
    return count;
  }

  Future<int?> getMalCountByMalAdi(String maladi) async {
    //database connection
    final db = await database;
    final count = Sqflite.firstIntValue(await db!.rawQuery(
        'SELECT COUNT(*) FROM AnbarStockMehsul  WHERE maladi=?', [maladi]));
    // assert(count == 2);
    return count;
  }

  Future<int?> getLasMusteriId() async {
    final db = await database;
    List<Map> maps = [];
    maps =
    await db!.query('Musteriler', orderBy: "id DESC", limit: 1, columns: [
      'id',
    ]);
    if (maps.isNotEmpty) {
      return (int.parse(maps[0]['id'].toString()) + 1);
    } else {
      return 1;
    }
  }

  Future<int?> getLasMehsulId() async {
    final db = await database;
    List<Map> maps = [];
    maps = await db!
        .query('AnbarStockMehsul', orderBy: "id DESC", limit: 1, columns: [
      'id',
    ]);
    if (maps.isNotEmpty) {
      return (int.parse(maps[0]['id'].toString()) + 1);
    } else {
      return 1;
    }
  }

  Future<int?> getLastStockHereketId() async {
    final db = await database;
    List<Map> maps = [];
    maps = await db!
        .query('AnbarStockHereket', orderBy: "id DESC", limit: 1, columns: [
      'id',
    ]);
    if (maps.isNotEmpty) {
      return (int.parse(maps[0]['id'].toString()) + 1);
    } else {
      return 1;
    }
  }

  Future<ModelStockHereket?> getLastStockHereketSonqaliq(String mehsulkodu) async {
    final db = await database;
    ModelStockHereket modelStockHereket;
    List<Map> maps = [];
    maps = await db!.query('AnbarStockHereket',
        orderBy: "id DESC",
        limit: 1,
        whereArgs: [mehsulkodu],
        where: "mehsulkodu = ?",
        columns: [
          'sonqaliq', "id"
        ]);
    if (maps.isNotEmpty) {
      modelStockHereket = ModelStockHereket(
          sonqaliq: maps[0]['sonqaliq'],
          id: maps[0]['1']
      );
    } else {
      modelStockHereket = ModelStockHereket(
          sonqaliq: 0,
          id: null
      );
    }
    return modelStockHereket;
  }

  //////////////tarixlere gore filter
  Future<List> selectbyAY(String ay) async{
    String tableName="";
    var db = await database;
    ///////%y-ile gore filter||||%m-ile aya gore|||%d-le gune gore ||||%H-le saata gore|||%M-le deqiqqeye gore
    List<Map> names = await db!.rawQuery('select AnbarStockHereket.mehsulkodu, strftime("%H", AnbarStockHereket.createDate) as ay from AnbarStockHereket where  strftime("%H", AnbarStockHereket.createDate)="22"');
return [];
  }
  Future<List> getRangeData(String fromDate, String toDate) async{
    String tableName="";
    var dbClient = await database;
    var result = await dbClient!.rawQuery("SELECT * FROM $tableName where createdate >= '2021-01-01' and createdate <= '2022-10-10' ");
    return result.toList();
  }
////////////////////////////////////////////////////

}
class ModelSenedTotal {
  double? totalehtiyyat;
  double? totalsumma;
  List<ModelMehsullar>? listMehsullar;

  ModelSenedTotal({
    this.totalehtiyyat,
    this.totalsumma,
    this.listMehsullar,
  });
}
