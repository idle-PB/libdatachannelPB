
#RTC_DEFAULT_MTU = 1280 ;// IPv6 minimum guaranteed MTU
#RTC_DEFAULT_MAXIMUM_FRAGMENT_SIZE = #RTC_DEFAULT_MTU-60  
#RTC_DEFAULT_MAXIMUM_PACKET_COUNT_FOR_NACK_CACHE = 512

#RTC_NEW = 0
#RTC_CONNECTING = 1
#RTC_CONNECTED = 2
#RTC_DISCONNECTED = 3
#RTC_FAILED = 4
#RTC_CLOSED = 5
;rtcState;

#RTC_ICE_NEW = 0
#RTC_ICE_CHECKING = 1
#RTC_ICE_CONNECTED = 2
#RTC_ICE_COMPLETED = 3
#RTC_ICE_FAILED = 4
#RTC_ICE_DISCONNECTED = 5
#RTC_ICE_CLOSED = 6
;rtcIceState;


#RTC_GATHERING_NEW = 0
#RTC_GATHERING_INPROGRESS = 1
#RTC_GATHERING_COMPLETE = 2
;rtcGatheringState;

#RTC_SIGNALING_STABLE = 0
#RTC_SIGNALING_HAVE_LOCAL_OFFER = 1
#RTC_SIGNALING_HAVE_REMOTE_OFFER = 2
#RTC_SIGNALING_HAVE_LOCAL_PRANSWER = 3
#RTC_SIGNALING_HAVE_REMOTE_PRANSWER = 4
;rtcSignalingState;

#RTC_LOG_NONE = 0
#RTC_LOG_FATAL = 1
#RTC_LOG_ERROR = 2
#RTC_LOG_WARNING = 3
#RTC_LOG_INFO = 4
#RTC_LOG_DEBUG = 5
#RTC_LOG_VERBOSE = 6
;rtcLogLevel;

#RTC_CERTIFICATE_DEFAULT = 0;// ECDSA
#RTC_CERTIFICATE_ECDSA = 1
#RTC_CERTIFICATE_RSA = 2
;rtcCertificateType;

;video
#RTC_CODEC_H264 = 0
#RTC_CODEC_VP8 = 1
#RTC_CODEC_VP9 = 2
#RTC_CODEC_H265 = 3
#RTC_CODEC_AV1 = 4

;audio
#RTC_CODEC_OPUS = 128
#RTC_CODEC_PCMU = 129
#RTC_CODEC_PCMA = 130
#RTC_CODEC_AAC = 131


#RTC_DIRECTION_UNKNOWN = 0
#RTC_DIRECTION_SENDONLY = 1
#RTC_DIRECTION_RECVONLY = 2
#RTC_DIRECTION_SENDRECV = 3
#RTC_DIRECTION_INACTIVE = 4
;rtcDirection;

#RTC_TRANSPORT_POLICY_ALL = 0
#RTC_TRANSPORT_POLICY_RELAY = 1
;rtcTransportPolicy;

#RTC_ERR_SUCCESS =0
#RTC_ERR_INVALID =-1   ;// invalid argument
#RTC_ERR_FAILURE =-2   ;// Runtime error
#RTC_ERR_NOT_AVAIL= -3 ;// element Not available
#RTC_ERR_TOO_SMALL= -4 ;// buffer too small

;// Define how OBUs are packetizied in a AV1 Sample
#RTC_OBU_PACKETIZED_OBU = 0
#RTC_OBU_PACKETIZED_TEMPORAL_UNIT = 1
;rtcObuPacketization;

;// Define how NAL units are separated in a H264/H265 sample
#RTC_NAL_SEPARATOR_LENGTH = 0               ;// first 4 bytes are NAL unit length
#RTC_NAL_SEPARATOR_LONG_START_SEQUENCE = 1  ;// 0x00, 0x00, 0x00, 0x01
#RTC_NAL_SEPARATOR_SHORT_START_SEQUENCE = 2 ;// 0x00, 0x00, 0x01
#RTC_NAL_SEPARATOR_START_SEQUENCE = 3       ;// long Or short start sequence
;rtcNalUnitSeparator;


PrototypeC rtcLogCallbackFunc(rtcLogLevel.i,*message);
PrototypeC rtcDescriptionCallbackFunc(pc.l,*sdp.p-utf8,*type.p-utf8,*ptr);
PrototypeC rtcCandidateCallbackFunc(pc.l,*cand.p-utf8,*mid.p-utf8,*ptr)  ;
PrototypeC rtcStateChangeCallbackFunc(pc.l, state.i,*ptr)                ;
PrototypeC rtcIceStateChangeCallbackFunc(pc.l,state.i,*ptr)              ;
PrototypeC rtcGatheringStateCallbackFunc(pc.l,state.i,*ptr)              ;
PrototypeC rtcSignalingStateCallbackFunc(pc.l,state.i,*ptr)              ;
PrototypeC rtcDataChannelCallbackFunc(pc.l,dc.l,*ptr)                    ;
PrototypeC rtcTrackCallbackFunc(pc.l,tr.l,*ptr)                          ;
PrototypeC rtcOpenCallbackFunc(id.l,*ptr)                                ;
PrototypeC rtcClosedCallbackFunc(id.l,*ptr)                              ;
PrototypeC rtcErrorCallbackFunc(id.l,*error.p-utf8,*ptr)                 ;
PrototypeC rtcMessageCallbackFunc(id.l,*message.p-utf8,size.l,*ptr)      ;
PrototypeC rtcInterceptorCallbackFunc(pc.l,*message.p-utf8,size.l,*ptr)  ;
PrototypeC rtcBufferedAmountLowCallbackFunc(id.l,*ptr)                   ;
PrototypeC rtcAvailableCallbackFunc(id.l,*ptr)                           ;
PrototypeC rtcPliHandlerCallbackFunc(tr.l,*ptr)                          ;
PrototypeC rtcWebSocketClientCallbackFunc(wsserver.l,ws.l,*ptr)          ;

Macro AlignC 
  Align #PB_Structure_AlignC 
EndMacro   

;// PeerConnection

Structure rtcConfiguration AlignC 
  *iceServers             ;
  iceServersCount.l       ;
  *proxyServer            ;p-utf8    // libnice only
  *bindAddress            ;p-utf8    // libjuice only, NULL means any
  certificateType.l       ;
  iceTransportPolicy.l    ;
  enableIceTcp.a          ;          // libnice only
  enableIceUdpMux.a       ;          // libjuice only
  disableAutoNegotiation.a;
  forceMediaTransport.a   ;
  portRangeBegin.u        ;          // 0 means automatic
  portRangeEnd.u          ;          // 0 means automatic
  mtu.l                   ;          // <= 0 means automatic
  maxMessageSize.l        ;          // <= 0 means default
EndStructure

Structure rtcReliability AlignC
  unordered.a;
  unreliable.a;
  maxPacketLifeTime.l    ;    // ignored if reliable
  maxRetransmits.l       ;    // ignored if reliable
EndStructure 

Structure rtcDataChannelInit AlignC
  reliability.rtcReliability;
  *protocol                 ;    // empty string if NULL
  negotiated.a              ;
  manualStream.a            ;
  stream.u                  ;    // numeric ID 0-65534, ignored if manualStream is false
EndStructure 

Structure rtcTrackInit AlignC
  direction.l         ;     rtcDirection;
  codec.l             ;     rtcCodec 
  payloadType.l       ;
  ssrc.l              ;
  *mid                ;     p-utf8
  *name               ;     // optional
  *msid               ;     // optional
  *trackId            ;     // optional, track ID used in MSID
  *profile            ;     // optional, codec profile
EndStructure 

Structure rtcPacketizationHandlerInit AlignC
  ssrc.l
  *cname              ;p-utf8;
  payloadType.a
  clockRate.l  
  sequenceNumber.u
  timestamp.l     
                      ;// H264/H265 only
  nalSeparator.l      ; rtcNalUnitSeparator// NAL unit separator
                      ;// H264, H265, AV1
  maxFragmentSize.l   ; // Maximum fragment size
                      ;// AV1 only
  obuPacketization.l  ; rtcObuPacketization// OBU paketization for AV1 samples
EndStructure 

Structure rtcSsrcForTypeInit AlignC
  ssrc.l           
  *name                     ;p-utf8;    // optional
  *msid                     ;p-utf8;    // optional
  *trackId                  ;p-utf8;    // optional, track ID used in MSID
EndStructure 

Structure rtcWsConfiguration AlignC;
  disableTlsVerification.a;                 // if true, don't verify the TLS certificate
  *proxyServer                 ;p-utf8;     // only non-authenticated http supported for now
  *protocols                   ;
  protocolsCount.l             ;
  connectionTimeoutMs.l        ;            // in milliseconds, 0 means default, < 0 means disabled
  pingIntervalMs.l             ;            // in milliseconds, 0 means default, < 0 means disabled
  maxOutstandingPings.l        ;            // 0 means default, < 0 means disabled
EndStructure 

Structure rtcWsServerConfiguration AlignC 
  port.u;                         // 0 means automatic selection
  enableTls.a;                    // if true, enable TLS (WSS)
  *certificatePemFile  ;p-utf8    // NULL for autogenerated certificate
  *keyPemFile          ;p-utf8    // NULL for autogenerated certificate
  *keyPemPass          ;p-utf8    // NULL if no pass
  *bindAddress         ;p-utf8    // NULL for IP_ANY_ADDR
  connectionTimeoutMs.l;      // in milliseconds, 0 means default, < 0 means disabled
EndStructure 

Structure rtcSctpSettings AlignC         
  recvBufferSize.l       ;          // in bytes, <= 0 means optimized default
  sendBufferSize.l       ;          // in bytes, <= 0 means optimized default
  maxChunksOnQueue.l     ;          // in chunks, <= 0 means optimized default
  initialCongestionWindow.l;        // in MTUs, <= 0 means optimized default
  maxBurst.l               ;        // in MTUs, 0 means optimized default, < 0 means disabled
  congestionControlModule.l;        // 0: RFC2581 (default), 1: HSTCP, 2: H-TCP, 3: RTCC
  delayedSackTimeMs.l      ;        // in milliseconds, 0 means optimized default, < 0 means disabled
  minRetransmitTimeoutMs.l ;        // in milliseconds, <= 0 means optimized default
  maxRetransmitTimeoutMs.l ;        // in milliseconds, <= 0 means optimized default
  initialRetransmitTimeoutMs.l;     // in milliseconds, <= 0 means optimized default
  maxRetransmitAttempts.l     ;     // number of retransmissions, <= 0 means optimized default
  heartbeatIntervalMs.l       ;      // in milliseconds, <= 0 means optimized default
EndStructure 

ImportC "libdatachannel.dll.a" 
  
  rtcInitLogger(level.i,*cb.rtcLogCallbackFunc)
  rtcSetUserPointer(id.l,*ptr)                 
  rtcGetUserPointer(id.l)                      
  rtcCreatePeerConnection(*config.rtcConfiguration); // returns pc id
  rtcClosePeerConnection(pc.l)                     
  rtcDeletePeerConnection(pc.l)                    
  
  rtcSetLocalDescriptionCallback(pc.l,*cb.rtcDescriptionCallbackFunc)
  rtcSetLocalCandidateCallback(pc.l, *cb.rtcCandidateCallbackFunc)   
  rtcSetStateChangeCallback(pc.l, *cb.rtcStateChangeCallbackFunc)    
  rtcSetIceStateChangeCallback(pc.l, *cb.rtcIceStateChangeCallbackFunc)
  rtcSetGatheringStateChangeCallback(pc.l,*cb.rtcGatheringStateCallbackFunc)
  rtcSetSignalingStateChangeCallback(pc.l,*cb.rtcSignalingStateCallbackFunc)
  
  rtcSetLocalDescription(pc.l,*type.p-utf8)
  rtcSetRemoteDescription(pc.l,*sdp.p-utf8,*type.p-utf8)
  rtcAddRemoteCandidate(pc.l,*cand.p-utf8,*mid.p-utf8)
  
  rtcGetLocalDescription(pc.l,*buffer,size.l)
  rtcGetRemoteDescription(pc.l,*buffer,size.l)
  
  rtcGetLocalDescriptionType(pc.l,*buffer,size.l)
  rtcGetRemoteDescriptionType(pc.l,*buffer,size.l)
  
  rtcGetLocalAddress(pc.l,*buffer,size.l)
  rtcGetRemoteAddress(pc.l,*buffer,size.l)
  
  rtcGetSelectedCandidatePair(pc.l,*local,localSize.l,*remote,remoteSize.l)
  
  rtcGetMaxDataChannelStream(pc.l)
  rtcGetRemoteMaxMessageSize(pc.l)
  
  ;// DataChannel, Track, And WebSocket common API
  
  rtcSetOpenCallback(id.l, *cb.rtcOpenCallbackFunc)
  rtcSetClosedCallback(id.l, *cb.rtcClosedCallbackFunc)
  rtcSetErrorCallback(id.l, *cb.rtcErrorCallbackFunc)  
  rtcSetMessageCallback(id.l, *cb.rtcMessageCallbackFunc)
  rtcSendMessage(id.l,*data,size.l)                      
  rtcClose(id.l)                                         
  rtcDelete(id.l)                                        
  rtcIsOpen(id.l)                                        
  rtcIsClosed(id.l)                                      
  
  rtcMaxMessageSize(id.l)
  rtcGetBufferedAmount(id.l)  ; // total size buffered to send
  rtcSetBufferedAmountLowThreshold(id.l, amount.l);
  rtcSetBufferedAmountLowCallback(id.l, *cb.rtcBufferedAmountLowCallbackFunc);
  
  ;// DataChannel, Track, And WebSocket common extended API
  
  rtcGetAvailableAmount(id.l);  // total size available to receive
  rtcSetAvailableCallback(id.l, *cb.rtcAvailableCallbackFunc)
  rtcReceiveMessage(id.l,*buffer,*size.long)                 
  
  ;// DataChannel
  
  rtcSetDataChannelCallback(pc.l, *cb.rtcDataChannelCallbackFunc)
  rtcCreateDataChannel(pc.l,*label.p-utf8)                           ; // returns dc id
  rtcCreateDataChannelEx(pc.l,*label.p-utf8,*init.rtcDataChannelInit); // returns dc id
  rtcDeleteDataChannel(dc.l)                                         
  
  rtcGetDataChannelStream(dc.l)
  rtcGetDataChannelLabel(dc.l,*buffer,size.l)
  rtcGetDataChannelProtocol(dc.l, *buffer, size.l)
  rtcGetDataChannelReliability(dc.l,*reliability.rtcReliability)
  
  ;// Track
  
  rtcSetTrackCallback(pc.l, *cb.rtcTrackCallbackFunc)
  rtcAddTrack(pc.l,*mediaDescriptionSdp.p-utf8)      ;  returns tr id
  rtcAddTrackEx(pc.l, *init.rtcTrackInit)            ;  returns tr id
  rtcDeleteTrack(tr.l)                               
  
  rtcGetTrackDescription(tr.l,*buffer,size.l)
  rtcGetTrackMid(tr.l,*buffer,size.l)        
  rtcGetTrackDirection(tr.l,*direction)      
    
  ;// Media
  ;// Allocate a new opaque message.
  ;// Must be explicitly freed by rtcDeleteOpaqueMessage() unless
  ;// explicitly returned by a media interceptor callback;
  rtcCreateOpaqueMessage(*data,size.l)
  rtcDeleteOpaqueMessage(*rtcMessage)
  
  ;// Set MediaInterceptor For peer connection
  rtcSetMediaInterceptorCallback(id.l, *cb.rtcInterceptorCallbackFunc)
  
  ;// Set H264PacketizationHandler For track
  rtcSetH264PacketizationHandler(tr.l,*init.rtcPacketizationHandlerInit)
  
  ;// Set H265PacketizationHandler For track
  rtcSetH265PacketizationHandler(tr.l, *init.rtcPacketizationHandlerInit)
  
  ;// Set AV1PacketizationHandler For track
  rtcSetAV1PacketizationHandler(tr.l,*init.rtcPacketizationHandlerInit)
  
  ;// Set OpusPacketizationHandler For track
  rtcSetOpusPacketizationHandler(tr.l, *init.rtcPacketizationHandlerInit)
  
  ;// Set AACPacketizationHandler For track
  rtcSetAACPacketizationHandler(tr.l, *init.rtcPacketizationHandlerInit)
  
  ;// Chain RtcpSrReporter To handler chain For given track
  rtcChainRtcpSrReporter(tr.l)
  
  ;// Chain RtcpNackResponder To handler chain For given track
  rtcChainRtcpNackResponder(tr.l,maxStoredPacketsCount.l)
  
  ;// Chain PliHandler To handler chain For given track
  rtcChainPliHandler(tr.l,*cb.rtcPliHandlerCallbackFunc)
  
  ;// Transform seconds To timestamp using track's clock rate, result is written to timestamp
  rtcTransformSecondsToTimestamp(id.l,seconds.d,*timestamp.long)
  
  ;// Transform timestamp To seconds using track's clock rate, result is written to seconds
  rtcTransformTimestampToSeconds(id.l, timestamp.l,*seconds.double)
  
  ;// Get current timestamp, result is written To timestamp
  rtcGetCurrentTrackTimestamp(id.l,*timestamp.long)
  
  ;// Set RTP timestamp For track identified by given id
  rtcSetTrackRtpTimestamp(id.l,timestamp.l)
  
  ;// Get timestamp of last RTCP SR, result is written To timestamp
  rtcGetLastTrackSenderReportTimestamp(id.l,*timestamp.long)
  
  ;// Set NeedsToReport flag in RtcpSrReporter handler identified by given track id
  rtcSetNeedsToSendRtcpSr(id.l)
  
  ;// Get all available payload types For given codec And stores them in buffer, does nothing If
  ;// buffer is NULL
  rtcGetTrackPayloadTypesForCodec(tr.l,*ccodec.p-utf8,*buffer,size)
  
  ;// Get all SSRCs For given track
  rtcGetSsrcsForTrack(tr.l,*buffer,count.l)
  
  ;// Get CName For SSRC
  rtcGetCNameForSsrc(tr.l,ssrc.l,*cname.p-utf8,cnameSize.l)
  
  ;// Get all SSRCs For given media type in given SDP
  rtcGetSsrcsForType(*mediaType.p-utf8,*sdp.p-utf8,*buffer,bufferSize.l)
  
  ;// Set SSRC For given media type in given SDP
  rtcSetSsrcForType(*mediaType.p-utf8,*sdp.p-utf8,*buffer,bufferSize.l,*init.rtcSsrcForTypeInit)

  ;// WebSocket
  rtcCreateWebSocket(url.p-utf8);   // returns ws id
  rtcCreateWebSocketEx(url.p-utf8,*config.rtcWsConfiguration)
  rtcDeleteWebSocket(ws.l)                                    
  
  rtcGetWebSocketRemoteAddress(ws.l,*buffer,size.l)
  rtcGetWebSocketPath(ws.l,*buffer,size.l)         
  
  ;// WebSocketServer
  rtcCreateWebSocketServer(*config.rtcWsServerConfiguration,*cb.rtcWebSocketClientCallbackFunc); // returns wsserver id
  rtcDeleteWebSocketServer(wsserver.l)                                                         
  rtcGetWebSocketServerPort(wsserver.l)                                                        
  
  ;// Optional Global preload And cleanup
  rtcPreload(void);
  rtcCleanup(void);

  ;// SCTP Global settings
  ;// Note: SCTP settings apply To newly-created PeerConnections only
  rtcSetSctpSettings(*settings.rtcSctpSettings);
EndImport 


CompilerIf #PB_Compiler_IsMainFile   
  
  Global *MESSAGE = UTF8("Hello, this is a C API WebSocket test!")

  Global success = #False;
  Global failed = #False;
  Global wsclient.l = -1;

ProcedureC openCallback(ws.l,*ptr)
	Debug "WebSocket: Connection open"
  
	If rtcSendMessage(ws,*MESSAGE,-1) < 0 ;negative size indicates a null-terminated string
		Debug "rtcSendMessage failed"
		failed = #True;
	EndIf 
EndProcedure 

ProcedureC closedCallback(ws.l,*ptr) 
  Debug "WebSocket: Connection closed" + Str(ws) 
EndProcedure   

ProcedureC messageCallback(ws.l,*pmessage,size.l,*ptr)
	If (size < 0  And CompareMemory(*pmessage,*MESSAGE,MemorySize(*MESSAGE)) <> 0) 
		Debug "WebSocket: Received expected message"
		success = #True;
	Else 
		Debug "Received UNEXPECTED message"
		failed = #True;
	EndIf 
EndProcedure 

ProcedureC serverOpenCallback(ws.l,*ptr)
	Debug "WebSocketServer: Client connection open"

	*path = AllocateMemory(256);
	If (rtcGetWebSocketPath(ws, *path, 256) < 0) 
		Debug "rtcGetWebSocketPath failed"
		failed = #True;
		FreeMemory(*path) 
		ProcedureReturn 
	EndIf 
	
	If PeekS(*path,-1,#PB_UTF8) <> "/mypath"
		Debug "Wrong WebSocket path: " + PeekS(*path,-1,#PB_UTF8);
		failed = #True;
	EndIf 
EndProcedure 	
	
ProcedureC  serverClosedCallback(ws.l,*ptr)
	 Debug "WebSocketServer: Client connection closed" 
EndProcedure 

ProcedureC serverMessageCallback(ws.l,*pmessage,size.l,*ptr)
	If (rtcSendMessage(ws, *pmessage, size) < 0) 
		Debug "rtcSendMessage failed"
		failed = #True;
	EndIf 
EndProcedure 

ProcedureC serverClientCallback(wsserver.l,ws.l,*ptr) 
	Protected  wsclient = ws;

	*address= AllocateMemory(256);
	If (rtcGetWebSocketRemoteAddress(ws, *address, 256) < 0) 
		Debug "rtcGetWebSocketRemoteAddress failed"
		failed = #True;
		FreeMemory(*address) 
		ProcedureReturn 
	EndIf 

	Debug "WebSocketServer: Received client connection from " + PeekS(*address,-1,#PB_UTF8);

	rtcSetOpenCallback(ws, @serverOpenCallback());
	rtcSetClosedCallback(ws, @serverClosedCallback());
	rtcSetMessageCallback(ws, @serverMessageCallback());
	
	FreeMemory(*address) 
	
EndProcedure 

ProcedureC  test_capi_websocketserver_main() 
	Protected  url.s = "wss://localhost:48081/mypath"
	Protected  port.u = 48081
	Protected  wsserver.l = -1;
	Protected  ws.l = -1;
	Protected  attempts.l;
	Protected  *path = AllocateMemory(256) 
	
	rtcInitLogger(#RTC_LOG_DEBUG,0);

	Protected serverConfig.rtcWsServerConfiguration
	
	serverConfig\port = port;
	serverConfig\enableTls = #True;
	
	;serverConfig.certificatePemFile = ...
	;serverConfig.keyPemFile = ...

	wsserver = rtcCreateWebSocketServer(@serverConfig, @serverClientCallback());
	If (wsserver < 0)
		Goto error;
  EndIf 
	If (rtcGetWebSocketServerPort(wsserver) <> port)
		Debug "rtcGetWebSocketServerPort failed";
		Goto error;
	EndIf 
		
	Protected config.rtcWsConfiguration
	
	config\disableTlsVerification = #True;
	config\connectionTimeoutMs = 3000 
	
	ws = rtcCreateWebSocketEx(url, @config);
	If (ws < 0)
		Goto error;
  EndIf 
  
  rtcGetWebSocketPath(ws,*path,256)  
	Debug PeekS(*path,-1,#PB_UTF8) 
	 
      
  rtcSetOpenCallback(ws, @openCallback());
	rtcSetMessageCallback(ws, @messageCallback());
	rtcSetClosedCallback(ws, @closedCallback());
	
	attempts = 10;
	While (success =0 And failed = 0 And attempts > 0)
	  Delay(100); 
	  attempts-1 
	Wend   

	If (success = 0 Or failed)
		Goto error;
  EndIf 
  
  rtcDeleteWebSocket(wsclient);
	Delay(100);

	rtcDeleteWebSocket(ws);
	Delay(100);

	rtcDeleteWebSocketServer(wsserver);
	Delay(100);

	Debug "Success"
	ProcedureReturn  

error:
  Debug "failed" 
  If (wsclient >= 0)
		rtcDeleteWebSocket(wsclient);
  EndIf 
	If (ws >= 0)
		rtcDeleteWebSocket(ws);
  EndIf 
	If (wsserver >= 0)
		rtcDeleteWebSocketServer(wsserver);
  EndIf 
	ProcedureReturn -1;
EndProcedure 

OpenConsole()

test_capi_websocketserver_main() 

Input()
CloseConsole()
  
CompilerEndIf   
