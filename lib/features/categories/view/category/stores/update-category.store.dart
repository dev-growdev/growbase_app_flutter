import 'package:dartz/dartz.dart';
import 'package:mobx/mobx.dart';

import '../../../../../shared/adapters/make-request.adapter.dart';
import '../../../../../shared/errors/failures.dart';
import '../../../entities/category.entity.dart';
import '../../../services/update-category.service.dart';

part 'update-category.store.g.dart';

class UpdateCategoryStore = _UpdateCategoryStore with _$UpdateCategoryStore;

abstract class _UpdateCategoryStore with Store {
  final UpdateCategoryService _service;

  _UpdateCategoryStore(this._service);

  @observable
  Category _state = const Category.empty();

  @computed
  Category get state => _state;

  @observable
  bool _isLoading = false;

  @computed
  bool get isLoading => _isLoading;

  @observable
  Failure? _failure;

  @computed
  Failure? get failure => _failure;

  @action
  void setState({
    String? uid,
    String? name,
    String? description,
  }) {
    _state = _state.copyWith(
      uid: uid,
      name: name,
      description: description,
    );
  }

  @action
  Future<bool> updateCategory() async {
    _failure = null;
    _isLoading = true;

    final resultOrError = await makeRequest(() => _service.call(state));

    _isLoading = false;

    if (resultOrError.isLeft()) {
      _failure = resultOrError.fold(id, id) as Failure;
      return false;
    }

    return true;
  }
}
