import 'package:bloc_test/bloc_test.dart';
import 'package:employee_ledger/blocs/employee_bloc.dart';
import 'package:employee_ledger/blocs/employee_event.dart';
import 'package:employee_ledger/blocs/employee_state.dart';
import 'package:employee_ledger/models/employee.dart';
import 'package:employee_ledger/services/database_helper.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import "package:flutter_test/flutter_test.dart";

import 'bloc_test.mocks.dart';

// Generate mocks with: flutter pub run build_runner build
@GenerateMocks([SembastHelper])
@GenerateMocks([SembastHelper])
void main() {
  late MockSembastHelper mockDbHelper;
  late EmployeeBloc employeeBloc;

  setUp(() {
    mockDbHelper = MockSembastHelper();
    employeeBloc = EmployeeBloc(mockDbHelper);
  });

  tearDown(() {
    employeeBloc.close();
  });

  group('EmployeeBloc', () {
    final testEmployee = Employee(
      id: 1,
      name: 'John Doe',
      role: 'Software Engineer',
      startDate: DateTime(2023, 1, 1),
      endDate: DateTime(2023, 12, 31),
    );

    final testEmployeeList = [testEmployee];

    blocTest<EmployeeBloc, EmployeeState>(
      'emits [EmployeeEmpty] when no employees exist',
      build: () => employeeBloc,
      seed: () => EmployeeLoading(),
      act: (bloc) async {
        when(mockDbHelper.getEmployees()).thenAnswer((_) async => []);
        bloc.add(LoadEmployees());
      },
      expect: () => [isA<EmployeeEmpty>()],
      verify: (_) {
        verify(mockDbHelper.getEmployees()).called(1);
      },
    );

    blocTest<EmployeeBloc, EmployeeState>(
      'emits [EmployeeLoaded] when employees exist',
      build: () => employeeBloc,
      seed: () => EmployeeLoading(),
      act: (bloc) {
        when(
          mockDbHelper.getEmployees(),
        ).thenAnswer((_) async => testEmployeeList);
        bloc.add(LoadEmployees());
      },
      expect:
          () => [
            isA<EmployeeLoaded>().having(
              (e) => e.employees,
              'employees',
              testEmployeeList,
            ),
          ],
      verify: (_) {
        verify(mockDbHelper.getEmployees()).called(1);
      },
    );

    blocTest<EmployeeBloc, EmployeeState>(
      'emits [EmployeeLoaded] when adding an employee',
      build: () => employeeBloc,
      seed: () => EmployeeLoading(),
      act: (bloc) {
        when(mockDbHelper.insertEmployee(any)).thenAnswer((_) async => 1);
        when(
          mockDbHelper.getEmployees(),
        ).thenAnswer((_) async => testEmployeeList);
        bloc.add(AddEmployee(testEmployee));
      },
      expect:
          () => [
            isA<EmployeeLoaded>().having(
              (e) => e.employees,
              'employees',
              testEmployeeList,
            ),
          ],
      verify: (_) {
        verify(mockDbHelper.insertEmployee(testEmployee)).called(1);
        verify(mockDbHelper.getEmployees()).called(1);
      },
    );

    blocTest<EmployeeBloc, EmployeeState>(
      'emits [EmployeeLoaded] when updating an employee',
      build: () => employeeBloc,
      seed: () => EmployeeLoading(),
      act: (bloc) {
        when(mockDbHelper.updateEmployee(any)).thenAnswer((_) async => 1);
        when(
          mockDbHelper.getEmployees(),
        ).thenAnswer((_) async => testEmployeeList);
        bloc.add(UpdateEmployee(testEmployee));
      },
      expect:
          () => [
            isA<EmployeeLoaded>().having(
              (e) => e.employees,
              'employees',
              testEmployeeList,
            ),
          ],
      verify: (_) {
        verify(mockDbHelper.updateEmployee(testEmployee)).called(1);
        verify(mockDbHelper.getEmployees()).called(1);
      },
    );
  });
}
