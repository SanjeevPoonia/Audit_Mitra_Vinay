

class FilterModel
{
  static List<dynamic>? subCategoryListFilter;
  static List<String> subCategoryListNames=[];
  static List<dynamic>? quantityListFilter;
  static List<dynamic>? gradesListFilter;
  static List<dynamic>? filterList;
  static String categoryID="";
  static String? productName;
  static String categoryName="";
  static bool filterApplied=false;

  static List? setSubcategoryFilterList(List<dynamic> data){
    subCategoryListFilter=data;
    return subCategoryListFilter;
  }
  static List? setSubcategoryNamesFilterList(List<String> data){
    subCategoryListNames=data;
    return subCategoryListNames;
  }
  static List? setQuantityFilterList(List<dynamic> data){
    quantityListFilter=data;
    return quantityListFilter;
  }
  static List? setFilterList(List<dynamic> data){
    filterList=data;
    return filterList;
  }
  static List? setGradesFilterList(List<dynamic> data){
    gradesListFilter=data;
    return gradesListFilter;
  }
  static String? setCategoryID(String id){
    categoryID=id;
    return categoryID;
  }
  static String? setProductName(String name){
    productName=name;
    return productName;
  }

  static String? setCatName(String name){
    categoryName=name;
    return categoryName;
  }

  static bool setFilterApplied(bool filter)
  {
    filterApplied=filter;
    return filterApplied;
  }




}