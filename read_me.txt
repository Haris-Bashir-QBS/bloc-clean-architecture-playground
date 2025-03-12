
Domain Layer
1.Entities
  Business objects of an application or a system

Repositories

Bridge between presentation and data layer
Repositories interact with local and remote data sources
Usecase call repository implementation



UI => Bloc => UseCase =uses=> Repository (Impl) =uses=> Local/Remote Data sources

Why we need a model when we have entities

Domain layer is independant of other layers . Entities are business objects that are used in app
even we can change model implementation from json to XML or something else.