import 'dart:async';

import '../../../../core/base_import.dart';
import '../../../spot/domain/entities/join_request_entity.dart';
import '../../../spot/domain/entities/request_entity.dart';
import '../../../spot/domain/usecases/get_confirmed_players_usecase.dart';
import '../../../spot/domain/usecases/get_spot_details_usecase.dart';
import 'group_info_screen_mobile.dart';
import 'group_info_screen_tablet.dart';

/// Group Info screen showing activity context, host, and confirmed participants.
class GroupInfoScreen extends StatefulWidget {
  final String spotId;
  final GetSpotDetailsUseCase getSpotDetailsUseCase;
  final GetConfirmedPlayersUseCase getConfirmedPlayersUseCase;
  final String? currentUserId;

  const GroupInfoScreen({
    super.key,
    required this.spotId,
    required this.getSpotDetailsUseCase,
    required this.getConfirmedPlayersUseCase,
    required this.currentUserId,
  });

  @override
  State<GroupInfoScreen> createState() => _GroupInfoScreenState();
}

class _GroupInfoScreenState extends State<GroupInfoScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  RequestEntity? _post;
  List<JoinRequestEntity> _confirmedPlayers = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final results = await Future.wait([
        widget.getSpotDetailsUseCase(widget.spotId),
        widget.getConfirmedPlayersUseCase(widget.spotId),
      ]);

      if (!mounted) return;

      setState(() {
        _post = results[0] as RequestEntity;
        _confirmedPlayers = results[1] as List<JoinRequestEntity>;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onBack() {
    unawaited(context.requestBack());
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    if (_isLoading) {
      return Scaffold(
        backgroundColor: context.backgroundColor,
        appBar: AppBar(
          backgroundColor: context.backgroundColor,
          elevation: 0,
          title: Text(context.loc.groupInfoTitle),
          leading: KhelBhaiBackButton(onPressed: _onBack),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null || _post == null) {
      return Scaffold(
        backgroundColor: context.backgroundColor,
        appBar: AppBar(
          backgroundColor: context.backgroundColor,
          elevation: 0,
          title: Text(context.loc.groupInfoTitle),
          leading: KhelBhaiBackButton(onPressed: _onBack),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  size: Dimensions.r48.dynamicH,
                  color: colors.error,
                ),
                SizedBox(height: Dimensions.r16.dynamicH),
                Text(
                  _errorMessage ?? context.loc.detailsLoadError,
                  textAlign: TextAlign.center,
                  style: context.bodyMedium?.copyWith(color: colors.error),
                ),
                SizedBox(height: Dimensions.r16.dynamicH),
                FilledButton(
                  onPressed: _loadData,
                  child: Text(context.loc.retry),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return ResponsiveLayout(
      mobile: GroupInfoScreenMobile(
        post: _post!,
        confirmedPlayers: _confirmedPlayers,
        currentUserId: widget.currentUserId,
        onBack: _onBack,
      ),
      tablet: GroupInfoScreenTablet(
        post: _post!,
        confirmedPlayers: _confirmedPlayers,
        currentUserId: widget.currentUserId,
        onBack: _onBack,
      ),
    );
  }
}
