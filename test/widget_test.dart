import 'package:employee_ledger/blocs/employee_bloc.dart';
import 'package:employee_ledger/blocs/employee_state.dart';
import 'package:employee_ledger/main.dart';
import 'package:employee_ledger/models/employee.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'bloc_test.mocks.dart';

void main() {
  late MockSembastHelper mockHelper;

  setUp(() {
    mockHelper = MockSembastHelper();
  });

  Widget createWidgetUnderTest(EmployeeBloc bloc) {
    return BlocProvider<EmployeeBloc>.value(
      value: bloc,
      child: const MaterialApp(
        home: EmployeeScreen(),
      ),
    );
  }

  testWidgets('Renders Empty State with call to action', (WidgetTester tester) async {
    final bloc = EmployeeBloc(mockHelper);
    when(mockHelper.getEmployees()).thenAnswer((_) async => []);

    await tester.pumpWidget(createWidgetUnderTest(bloc));
    bloc.emit(EmployeeEmpty());
    await tester.pumpAndSettle();

    expect(find.text('No Employees in Ledger'), findsOneWidget);
    expect(find.text('Add First Employee'), findsOneWidget);
  });

  testWidgets('Renders KPI metrics and Employee list when data is loaded', (WidgetTester tester) async {
    final bloc = EmployeeBloc(mockHelper);
    final mockEmployees = [
      Employee(
        id: 1,
        name: 'Sarah Connor',
        role: 'Product Designer',
        startDate: DateTime(2023, 1, 15),
      ),
      Employee(
        id: 2,
        name: 'John Connor',
        role: 'Flutter Developer',
        startDate: DateTime(2021, 6, 1),
        endDate: DateTime(2023, 12, 31),
      ),
    ];

    await tester.pumpWidget(createWidgetUnderTest(bloc));
    bloc.emit(EmployeeLoaded(mockEmployees));
    await tester.pumpAndSettle();

    // Verify KPI Cards
    expect(find.text('Total Team'), findsOneWidget);
    expect(find.text('Active'), findsNWidgets(2));
    expect(find.text('Alumni'), findsNWidgets(2));

    // Verify Employee Cards
    expect(find.text('Sarah Connor'), findsOneWidget);
    expect(find.text('John Connor'), findsOneWidget);
    expect(find.text('Product Designer'), findsOneWidget);
    expect(find.text('Flutter Developer'), findsOneWidget);
  });

  testWidgets('Filters employees using Search Field', (WidgetTester tester) async {
    final bloc = EmployeeBloc(mockHelper);
    final mockEmployees = [
      Employee(
        id: 1,
        name: 'Alice Cooper',
        role: 'QA Lead',
        startDate: DateTime(2022, 1, 1),
      ),
      Employee(
        id: 2,
        name: 'Bob Vance',
        role: 'Backend Architect',
        startDate: DateTime(2022, 1, 1),
      ),
    ];

    await tester.pumpWidget(createWidgetUnderTest(bloc));
    bloc.emit(EmployeeLoaded(mockEmployees));
    await tester.pumpAndSettle();

    // Type in search bar
    await tester.enterText(find.byType(TextField), 'Alice');
    await tester.pumpAndSettle();

    expect(find.text('Alice Cooper'), findsOneWidget);
    expect(find.text('Bob Vance'), findsNothing);
  });
}
