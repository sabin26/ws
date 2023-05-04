import 'dart:async';

import 'package:ws/src/model/web_socket_ready_state.dart';

/// Crossplatform binding to the native WebSocket.
///
/// The WebSocket object provides the API for creating and managing
/// a WebSocket connection to a server, as well as for sending
/// and receiving data on the connection.
abstract interface class IWebSocketPlatformTransport implements Sink<Object> {
  /// The URL that was used to establish the connection.
  abstract final String url;

  /// Stream of message events handled by this WebSocket.
  abstract final Stream<Object> stream;

  /// Returns the current state of the connection.
  /// 0	: CONNECTING - Socket has been created. The connection is not yet open.
  /// 1	: OPEN       - The connection is open and ready to communicate.
  /// 2	: CLOSING    - The connection is in the process of closing.
  /// 3	: CLOSED     - The connection is closed or couldn't be opened.
  WebSocketReadyState get readyState;

  /// The close code set when the WebSocket connection is closed.
  /// If there is no close code available this property will be null.
  int? get closeCode;

  /// The close reason set when the WebSocket connection is closed.
  /// If there is no close reason available this property will be null.
  String? get closeReason;

  /// Whether the stream controller is permanently closed.
  ///
  /// The controller becomes closed by calling the [close] method.
  ///
  /// If the controller is closed,
  /// the "done" event might not have been delivered yet,
  /// but it has been scheduled, and it is too late to add more events.
  bool get isClosed;

  /// A future which is completed when the stream controller is done.
  Future<void> get done;

  /// The extensions property is initially null.
  /// After the WebSocket connection is established
  /// this string reflects the extensions used by the server.
  String? get extensions;

  /// Connects to the WebSocket server.
  Future<void> connect();

  /// Closes the WebSocket connection.
  /// Set the optional [code] and [reason] arguments
  /// to send close information to the remote peer.
  /// If they are omitted, the peer will see
  /// `No Status Rcvd (1005)` code with no reason,
  /// indicates that no status code was provided even though one was expected.
  /// https://developer.mozilla.org/en-US/docs/Web/API/CloseEvent/code
  void disconnect([int? code, String? reason]);

  /// Sends data on the WebSocket connection.
  /// The data in data must be either a String, or a List<int> holding bytes.
  @override
  void add(/* String || List<int> || ByteBuffer || TypedData */ Object data);

  /// Permanently stops the WebSocket connection and frees all resources.
  /// After calling this method the WebSocket client is no longer usable.
  ///
  /// Use [disconnect] to temporarily close the connection.
  /// And reconnect with [connect] method later.
  @override
  void close([int? code = 1000, String? reason = 'Normal Closure']);
}
