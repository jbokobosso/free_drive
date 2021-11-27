import 'package:flutter/material.dart';
import 'package:free_drive/ui/pages/dashboard/DashboardViewModel.dart';
import 'package:free_drive/ui/pages/dashboard/StatusBadge.dart';
import 'package:free_drive/ui/shared/CustomAppBar.dart';
import 'package:free_drive/ui/shared/Loading.dart';
import 'package:free_drive/utils/Utils.dart';
import 'package:stacked/stacked.dart';

class LoadsHistoryPage extends StatelessWidget {
  LoadsHistoryPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DashboardViewModel>.reactive(
      onModelReady: (model) => model.loadPendingPayments(),
      builder: (context, model, child) => Scaffold(
        appBar: CustomAppBar(title: 'Historique Portefeuille', refreshCallback: model.refreshPendingPayments),
        extendBodyBehindAppBar: true,
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            RefreshIndicator(
              onRefresh: model.refreshPendingPayments,
              child: Container(
                padding: EdgeInsets.only(
                    left: model.deviceWidth*0.07,
                    right: model.deviceWidth*0.07,
                    bottom: model.deviceHeight*0.1
                ),
                width: model.deviceWidth,
                height: model.deviceHeight,
                color: Theme.of(context).accentColor,
                child: ListView.builder(
                  itemCount: model.pendingPayments.length,
                  itemBuilder: (context, index) => ListTile(
                    onTap: () => model.confirmPayment(model.pendingPayments[index]),
                    title: Text(model.pendingPayments[index].payment_method),
                    subtitle: model.pendingPayments[index].datetime == null
                        ? Text('N/A')
                        : Text("${Utils.formatDateToHuman(model.pendingPayments[index].datetime)}\nà ${Utils.formatTimeToHuman(TimeOfDay.fromDateTime(model.pendingPayments[index].datetime))}"),
                    trailing: StatusBadge(model.pendingPayments[index])
                  )
                )
              ),
            ),
            model.isBusy ? LoadingMini() : Container()
          ],
        ),
      ),
      viewModelBuilder: () => DashboardViewModel(),
    );
  }
}
