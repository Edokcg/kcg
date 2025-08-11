--极神圣帝 奥丁
local s, id = GetID()
function s.initial_effect(c)
	aux.god(c,1,id,0)

    local e0 = Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_CANNOT_DISABLE)
    e0:SetCode(805)
    e0:SetValue(0)
    c:RegisterEffect(e0)

	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTuner(nil),2,99)
	c:EnableReviveLimit()
	
	local te = Effect.CreateEffect(c)
    te:SetType(EFFECT_TYPE_IGNITION)
	te:SetRange(LOCATION_MZONE)
	te:SetCountLimit(1)
	te:SetTarget(s.detg)
	te:SetOperation(s.desactivate)
	c:RegisterEffect(te)
	
	--被破坏进墓地结束阶段特殊召唤
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetOperation(s.regop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(817,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.spcon)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
	
	--墓地特召时从卡组抽卡
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(817,2))
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(s.drcon)
	e5:SetTarget(s.drtg)
	e5:SetOperation(s.drop)
	c:RegisterEffect(e5)
end
-------------------------------------------------------------------------------
function s.agfilter(c)
    return c:IsFaceup() and c:IsRace(RACE_DIVINE)
end
function s.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(s.agfilter, tp, LOCATION_MZONE, 0,  nil) > 0 end
end
function s.desactivate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.agfilter, tp, LOCATION_MZONE, 0,  nil)
	if #g < 1 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(s.gfilter)
	e1:SetValue(s.efilter)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function s.gfilter(e, c)
    return c:IsFaceup() and c:IsRace(RACE_DIVINE)
end
function s.efilter(e, te)
    return te:IsActiveType(TYPE_SPELL + TYPE_TRAP)
end
-------------------------------------------------------------------------------
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local pos=c:GetPreviousPosition()
	if c:IsReason(REASON_BATTLE) then pos=c:GetBattlePosition() end
	if rp~=tp and c:GetPreviousControler()==tp and c:IsReason(REASON_DESTROY)
		and c:IsPreviousLocation(LOCATION_ONFIELD) and bit.band(pos,POS_FACEUP)~=0 then
		c:RegisterFlagEffect(817,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(817)~=0
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,1,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),1,tp,tp,false,false,POS_FACEUP)
	end
end
---------------------------------------------------------------------------------------------------------------
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end

function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
