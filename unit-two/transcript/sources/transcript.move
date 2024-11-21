module transcript::transcript {
    use sui::object::{Self};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;
    use sui::event;

    public struct WrappableTranscript has key, store{
        id: UID,
        history: u8,
        math: u8,
        literature: u8,
    }

    public struct Folder has key {
        id: UID,
        transcript: WrappableTranscript,
        intended_address: address,
    }

    public struct TeacherCap has key {
        id: UID,
    }

    // event
    public struct TranscriptRequestEvent has copy, drop{
        wrapper_id: ID,
        requester: address,
        intended_address: address,
    }

    fun init(ctx: &mut TxContext) {
        transfer::transfer(TeacherCap{id: object::new(ctx)}, tx_context::sender(ctx));
    }

    public entry fun add_additional_teacher(_: &TeacherCap, new_teacher_address: address, ctx: &mut TxContext){
        transfer::transfer(TeacherCap{id: object::new(ctx)}, new_teacher_address);
    }

    public  entry fun create_wrappable_transcript_object(_: &TeacherCap, history: u8, math: u8, literature: u8, ctx: &mut TxContext) {
        let transcriptObject = WrappableTranscript {
            id: object::new(ctx),
            history,
            math,
            literature,
        };
        transfer::transfer(transcriptObject, tx_context::sender(ctx));
    }
    
    public entry fun request_transcript(transcript: WrappableTranscript, intended_address: address, ctx: &mut TxContext) {
        let folderObject = Folder {
            id: object::new(ctx),
            transcript: transcript,
            intended_address,
        };


        event::emit(TranscriptRequestEvent{
            wrapper_id: object::uid_to_inner(&folderObject.id),
            requester: tx_context::sender(ctx),
            intended_address,
        });

        transfer::transfer(folderObject, intended_address);
    }

    public entry fun unpack_wrapped_transcript(folder: Folder, ctx: &mut TxContext) {
        assert!(folder.intended_address == tx_context::sender(ctx), 0);
        let Folder {
            id,
            transcript,
            intended_address: _,
        } = folder;
        
        transfer::transfer(transcript, tx_context::sender(ctx));

        object::delete(id);
    }

    public fun view_score(transcriptObject: &WrappableTranscript): u8 {
        transcriptObject.literature
    }

    public entry fun update_score(_: &TeacherCap,transcriptObject: &mut WrappableTranscript, score: u8) {
        transcriptObject.literature = score;
    }

    public entry fun delete_transcript(_: &TeacherCap, transcriptObject: WrappableTranscript) {
        let WrappableTranscript {id, history: _, math: _, literature: _} = transcriptObject;
        object::delete(id);
    }
}
