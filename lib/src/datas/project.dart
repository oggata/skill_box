import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skill_box/src/datas/interest.dart';
import 'package:skill_box/src/datas/user.dart';

class Project {
  String adminId;
  String projectId;
  String titulo;
  String descricao;
  Timestamp dataCriacao;
  List<User> membros;
  List<Interest> interesses;
  List<User> convites;

  Project.fromDocument(DocumentSnapshot document) {
    projectId = document.documentID;
    adminId = document.data["adminId"];
    titulo = document.data["titulo"];
    descricao = document.data["descricao"];
    dataCriacao = document.data["dataCriacao"];
    interesses = [];
    membros = [];
    convites = [];
  }

  Project.fromMap(Map<String, dynamic> projectData) {
    projectId = projectData["projectId"];
    adminId = projectData["adminId"];
    titulo = projectData["titulo"];
    descricao = projectData["descricao"];
    dataCriacao = projectData["dataCriacao"];
  }

  Map<String, dynamic> toMap() {
    return {
      "adminId": adminId,
      "projectId": projectId,
      "titulo": titulo,
      "descricao": descricao,
      "interesses": interesses.toList(),
      "membros": membros.toList(),
      "dataCriacao": dataCriacao
    };
  }
  
}