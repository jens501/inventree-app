
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:infinite_scroll_pagination/infinite_scroll_pagination.dart";

import "package:inventree/api.dart";
import "package:inventree/inventree/company.dart";
import 'package:inventree/inventree/model.dart';
import "package:inventree/inventree/sentry.dart";
import "package:inventree/widget/paginator.dart";
import "package:inventree/widget/refreshable_state.dart";
import "package:inventree/widget/company_detail.dart";

import "package:inventree/l10.dart";


class CompanyListWidget extends StatefulWidget {

  const CompanyListWidget(this.title, this.filters, {Key? key}) : super(key: key);

  final String title;

  final Map<String, String> filters;

  @override
  _CompanyListWidgetState createState() => _CompanyListWidgetState(title, filters);
}


class _CompanyListWidgetState extends RefreshableState<CompanyListWidget> {

  _CompanyListWidgetState(this.title, this.filters);

  final String title;

  final Map<String, String> filters;

  @override
  String getAppBarTitle(BuildContext context) => title;

  @override
  Widget getBody(BuildContext context) {

    return PaginatedCompanyList(filters);

  }

}


class PaginatedCompanyList extends StatefulWidget {

  const PaginatedCompanyList(this.filters, {this.onTotalChanged});

  final Map<String, String> filters;

  final Function(int)? onTotalChanged;

  @override
  _CompanyListState createState() => _CompanyListState(filters);
}

class _CompanyListState extends PaginatedSearchState<PaginatedCompanyList> {

  _CompanyListState(Map<String, String> filters) : super(filters);

  @override
  Future<InvenTreePageResponse?> requestPage(int limit, int offset, Map<String, String> params) async {

    final page = await InvenTreeCompany().listPaginated(limit, offset, filters: params);

    return page;
  }

  @override
  Widget buildItem(BuildContext context, InvenTreeModel model) {

    InvenTreeCompany company = model as InvenTreeCompany;

    return ListTile(
      title: Text(company.name),
      subtitle: Text(company.description),
      leading: InvenTreeAPI().getImage(
        company.image,
        width: 40,
        height: 40
      ),
      onTap: () async {
        Navigator.push(context, MaterialPageRoute(builder: (context) => CompanyDetailWidget(company)));
      },
    );
  }
}