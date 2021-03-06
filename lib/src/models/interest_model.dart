import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:skill_box/src/datas/Interest_category.dart';
import 'package:skill_box/src/datas/interest.dart';

class InterestModel extends Model{
  final _firestore = Firestore.instance;

  bool isLoading = false;

  static Interest filterInterest;
  String filterCategoryId;

  List<InterestCategory> interestCategories = [];

  List<Interest> interestsSelected = [];

  static InterestModel of(BuildContext context) => ScopedModel.of<InterestModel>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);

    _loadInterestsCategories();
  }

  Future<Null> _loadInterestsCategories() async {
    isLoading = true;
    notifyListeners();

    QuerySnapshot query = await _firestore.collection("interesses").getDocuments();

    interestCategories = query.documents.map((doc) => InterestCategory.fromDocument(doc)).toList();

    _loadInterestsItems(query);

    isLoading = false;
    notifyListeners();
  }

  Future<Null> _loadInterestsItems(QuerySnapshot query) async {
    interestCategories.map(
      (categoria) async {
        query = await _firestore.collection("interesses").document(categoria.categoryId).collection("itens").getDocuments();
        
        categoria.interests = query.documents.map((doc) => Interest.fromDocument(doc, false)).toList();
      }
    ).toList();
  }

  void setInterestsSelected(List<Interest> userInterests){
    clearSelections();

    interestsSelected = userInterests;

    notifyListeners();
  }

  bool isCategorySelected(InterestCategory category){
    if(interestsSelected != null){
      interestsSelected.map(
        (interest){
          if(category.categoryId == interest.categoryId){
            if(interest.isSelected){
              category.isSelected = true;
              filterCategoryId = interest.categoryId;
            }else{
              category.isSelected = false;
            }
          }
        }
      ).toList();
    }

    return category.isSelected;
  }

  void onTapInterest(Interest interest){
    bool find = false;

    interestsSelected.map(
      (userInterest){
        if(userInterest.interestId == interest.interestId){
          userInterest.isSelected = !userInterest.isSelected;
          find = true;
        }
      }
    ).toList();

    if(!find){
      interest.isSelected = !interest.isSelected;
    }
    notifyListeners();
  }

  void onTapFilterInterest(Interest interest){
    if(filterInterest != null && filterInterest.interestId == interest.interestId){
      filterInterest = null;
    }else{
      filterCategoryId = interest.categoryId;
      filterInterest = interest;
    }
    
    notifyListeners();
  }

  void clearSelections(){
    interestsSelected = [];

    interestCategories.map(
      (category){
        category.isSelected = false;
        category.interests.map(
          (interest){
            interest.isSelected = false;
          }
        ).toList();
      }
    ).toList();
  }
}