type pcap = (string * int64 option) option
(** Packet capture configuration. None means don't capture; Some (file, limit)
    means write pcap-formatted data to file. If the limit is None then the
    file will grow without bound; otherwise the file will be closed when it is
    bigger than the given limit. *)

module Make(Vmnet: Sig.VMNET)(Resolv_conv: Sig.RESOLV_CONF)(Time: V1_LWT.TIME): sig

  type config = {
    peer_ip: Ipaddr.V4.t;
    local_ip: Ipaddr.V4.t;
    pcap_settings: pcap Active_config.values;
  }
  (** A slirp TCP/IP stack ready to accept connections *)

  val create: Active_config.t -> config Lwt.t
  (** Initialise a TCP/IP stack, taking configuration from the Active_config.t *)

  type stack

  val connect: config -> Vmnet.fd -> stack Lwt.t
  (** Read and write ethernet frames on the given fd *)

  val after_disconnect: stack -> unit Lwt.t
  (** Waits until the stack has been disconnected *)
end

val print_pcap: pcap -> string

val client_macaddr: Macaddr.t

val server_macaddr: Macaddr.t
