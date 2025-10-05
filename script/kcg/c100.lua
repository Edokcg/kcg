--シューティング·スター·ドラゴン
local s, id = GetID()
function s.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsType,TYPE_SYNCHRO),1,1,aux.FilterSummonCode(44508094),1,1)
	c:EnableReviveLimit()

	--multi attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(24696097,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.mtcon)
	e1:SetOperation(s.mtop)
	c:RegisterEffect(e1)

	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(24696097,1))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	--e2:SetCountLimit(1) 
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.discon)
	e2:SetTarget(s.distg)
	e2:SetOperation(s.disop)
	c:RegisterEffect(e2)

	--disable attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,4))
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCondition(s.dacon2)
	e3:SetTarget(s.datg2)
	e3:SetOperation(s.daop2)
	c:RegisterEffect(e3)

	--synchro effect
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(50091196,1))
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_UNCOPYABLE)  
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,TIMING_END_PHASE+TIMING_MAIN_END)  
	e5:SetRange(LOCATION_EXTRA)
	e5:SetCondition(s.sccon)
	e5:SetTarget(s.sctarg)
	e5:SetOperation(s.scop)
	c:RegisterEffect(e5)
end
s.listed_names={44508094}

function s.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5
end
function s.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	local ct=g:FilterCount(Card.IsType,nil,TYPE_TUNER)
	Duel.ShuffleDeck(tp)
	if ct>1 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(ct-1)
		c:RegisterEffect(e1)
	elseif ct==0 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_ATTACK)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
	end
end
function s.dircon(e)
	return e:GetHandler():GetAttackAnnouncedCount()>0
end
function s.dircon2(e)
	return e:GetHandler():IsDirectAttacked()
end

function s.discon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentPhase()==PHASE_END then return false end
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsChainNegatable(ev) then return false end
	if re:IsHasCategory(CATEGORY_NEGATE)
		and Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT):IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return ex and tg~=nil and tc+tg:FilterCount(Card.IsOnField,nil)-tg:GetCount()>0 and not e:GetHandler():IsStatus(STATUS_CHAINING) 
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end

function s.dacon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer() and Duel.GetCurrentPhase()~=PHASE_END 
end
function s.datg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() end
	local c=e:GetHandler()
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function s.daop2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	if Duel.Remove(c,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)==0 then return end

	  if Duel.GetCurrentPhase()==PHASE_BATTLE_STEP 
	  and Duel.GetAttacker()~=nil and Duel.GetAttacker():CanAttack() and Duel.GetAttacker():GetControler()~=e:GetHandlerPlayer() 
	  and Duel.SelectYesNo(tp,aux.Stringid(84013237,0)) then
	  c:RegisterFlagEffect(100,RESET_PHASE+PHASE_END,0,1)   
	  Duel.NegateAttack() end

	--disable attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(24696097,2))
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_BATTLE_PHASE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.dacon)
	e1:SetTarget(s.datg)
	e1:SetOperation(s.daop)
	e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCountLimit(1)
	e2:SetOperation(s.retop)
	e2:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e2)
	end
end
function s.dacon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetCurrentPhase()==PHASE_BATTLE_STEP 
	  and Duel.GetAttacker()~=nil and Duel.GetAttacker():CanAttack() and Duel.GetAttacker():GetControler()~=e:GetHandlerPlayer() 
	  and e:GetHandler():GetFlagEffect(100)==0
end
function s.datg(e,tp,eg,ep,ev,re,r,rp,chk)
	  if chk==0 then return true end
end
function s.daop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.NegateAttack()
end
function s.retop(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP) end
end

function s.sccon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.GetTurnPlayer()~=tp
		--and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
--and Duel.CheckSynchroMaterial(e:GetHandler(),s.filter1,s.filter2,1,1) 
end
function s.sctarg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSynchroSummonable(nil) end
--e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_EXTRA)
end
function s.filter1(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsFaceup()
end
function s.filter2(c)
	return c:IsCode(44508094) and c:IsFaceup()
end
function s.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	--if c:GetControler()~=tp or not c:IsRelateToEffect(e) then return end
	  --local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,c) 
	--local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,c) 
	--if g:GetCount()>0 then 
		--Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON) 
		Duel.SynchroSummon(tp,c,nil)
		--local sg=g:Select(tp,1,1,nil) 
		--Duel.SynchroSummon(tp,sg:GetFirst(),c) 
	end 
end
