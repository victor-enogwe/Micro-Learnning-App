function categoryModelCollection () {
  const CategoryModel = Backbone.Model.extend({
    toString () { return this.get('name'); }
  });

  const CategoryCollection = Backbone.Collection.extend({
    url: '/api/v1/categories',
    model: CategoryModel,
    parse: data => data.data.categories
  });

  return { CategoryModel, CategoryCollection }
}
