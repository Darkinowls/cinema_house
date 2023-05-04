import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinema_house/core/date_format_extention.dart';
import 'package:cinema_house/features/tickets/cubit/tickets_cubit.dart';
import 'package:cinema_house/ui/widgets/loader.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/locale_keys.g.dart';
import '../domain/entities/ticket_entity.dart';

class TicketList extends StatelessWidget {
  const TicketList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TicketsCubit, TicketsState>(
      builder: (context, state) {
        if (state.status == TicketsStatus.loading) {
          return const Loader();
        }

        if (state.tickets.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text( LocaleKeys.noTickets.tr() , style: const TextStyle(fontSize: 28)),
                const SizedBox(height: 25),
                Text(LocaleKeys.youCanBuyThemInTheMoviesTab.tr())
              ],
            ),
          );
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: state.tickets.length,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return Column(
                      children: [
                        _generateDateContainer(state.tickets.elementAt(0)),
                        _generateListTile(context, state.tickets.elementAt(0)),
                      ],
                    );
                  }

                  Widget dateContainer = const SizedBox();
                  if (index != state.tickets.length - 1 &&
                      (state.tickets.elementAt(index).dateTime.day !=
                          state.tickets.elementAt(index + 1).dateTime.day)) {
                    dateContainer = _generateDateContainer(
                        state.tickets.elementAt(index + 1));
                  }
                  return Column(
                    children: [
                      _generateListTile(
                          context, state.tickets.elementAt(index)),
                      dateContainer,
                    ],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _showQRCode(BuildContext context, TicketEntity ticket) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Cinema house',
              style: TextStyle(color: Colors.black)),
          content: SizedBox(
            width: 300,
            height: 300,
            child: Center(
              child: QrImage(
                data: "${ticket.movieId} ${ticket.name} ${ticket.dateTime} "
                    "${ticket.rowIndex} ${ticket.seatIndex}",
                version: QrVersions.auto,
                size: 300,
                foregroundColor: Colors.black,
              ),
            ),
          )),
    );
  }

  Container _generateDateContainer(TicketEntity ticketEntity) {
    DateTime dateTime = ticketEntity.dateTime;
    return Container(
      height: 25,
      color: Colors.black12,
      child: Center(child: Text(dateTime.formatDate())),
    );
  }

  Widget _generateListTile(BuildContext context, TicketEntity ticketEntity) {
    return ListTile(
      leading: CachedNetworkImage(
          imageUrl: ticketEntity.smallImage,
          height: 100,
          width: 50,
          fit: BoxFit.contain),
      title: Text(ticketEntity.name),
      subtitle: Text(
          "Room: ${ticketEntity.roomName} + Row: ${ticketEntity.rowIndex} + Seat: ${ticketEntity.seatIndex}"),
      trailing: Text(ticketEntity.dateTime.formatTime()),
      onTap: () => _showQRCode(context, ticketEntity),
    );
  }
}
