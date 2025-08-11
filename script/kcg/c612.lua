--i 源數希望皇 Hope (KA)
local s,id=GetID()
function s.initial_effect(c)
	Xyz.AddProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x14b),11,2)		
	c:EnableReviveLimit()

	--cannot special summon
	-- local e0=Effect.CreateEffect(c)
	-- e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	-- e0:SetType(EFFECT_TYPE_SINGLE)
	-- e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	-- e0:SetValue(s.splimit)
	-- c:RegisterEffect(e0) 

	--Skip Draw Phase
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTargetRange(1,0)
	e2:SetCode(EFFECT_CANNOT_DRAW)
	e2:SetCondition(s.dcondition)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	c:RegisterEffect(e3)

	--atk
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCode(EFFECT_SET_ATTACK)
	e11:SetValue(s.atkval)
	c:RegisterEffect(e11)
	local e13=e11:Clone()
	e13:SetCode(EFFECT_SET_DEFENSE)
	c:RegisterEffect(e13)

	local e12=Effect.CreateEffect(c)
	e12:SetCategory(CATEGORY_REMOVE)
	e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e12:SetRange(LOCATION_MZONE)
	e12:SetCode(EVENT_PHASE+PHASE_END)
	e12:SetCountLimit(1)
	e12:SetTarget(s.tg)
	e12:SetOperation(s.op)
	c:RegisterEffect(e12)

	-- local e5=Effect.CreateEffect(c)
	-- e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	-- e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	-- e5:SetCode(EVENT_SUMMON_SUCCESS)
	-- e5:SetOperation(s.atkop)
	-- c:RegisterEffect(e5)
	-- local e10=e5:Clone()
	-- e10:SetCode(EVENT_SPSUMMON_SUCCESS)
	-- c:RegisterEffect(e10)
	-- local e98=e5:Clone()
	-- e98:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	-- c:RegisterEffect(e98)
end
s.listed_series={0x14b}
s.listed_names={41418852,593,654}

function s.splimit(e,se,sp,st)
	return se:GetHandler():IsCode(593) 
end

function s.dcondition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(e:GetHandler():GetControler(),LOCATION_HAND,0)==0
end

function s.atkval(e,c)
		return Duel.GetFieldGroupCount(e:GetHandler():GetControler(),LOCATION_MZONE,LOCATION_MZONE)*1000
end

function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() end
	local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,sg:GetCount(),0,0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 and c:IsRelateToEffect(e) and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
	local rg=Duel.GetOperatedGroup()
	rg:KeepAlive()
	rg:ForEach(function(c) c:RegisterFlagEffect(612,RESET_EVENT+0x1fe0000,0,1)
	end)

	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10449150,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e4:SetRange(LOCATION_REMOVED)
	e4:SetCountLimit(1)
	e4:SetCondition(s.spcon)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	if Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE and Duel.GetTurnPlayer()==1-tp then
		e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE+RESET_OPPO_TURN,2)
	else
		e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE+RESET_OPPO_TURN,1)
	end
	c:RegisterEffect(e4)

	local e5=Effect.CreateEffect(c) 
	e5:SetDescription(aux.Stringid(10449150,2)) 
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F) 
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET) 
	e5:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e5:SetCondition(s.damcon) 
	e5:SetTarget(s.damtg) 
	e5:SetOperation(s.damop)  
	e5:SetLabelObject(rg)
	if Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE and Duel.GetTurnPlayer()==1-tp then
		e5:SetReset(RESET_EVENT+0x1fe0000-RESET_TOFIELD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
	else
		e5:SetReset(RESET_EVENT+0x1fe0000-RESET_TOFIELD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,1)
	end
	c:RegisterEffect(e5) end	
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	  if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_SPECIAL+1,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	Duel.SpecialSummon(e:GetHandler(),SUMMON_TYPE_SPECIAL+1,tp,tp,false,false,POS_FACEUP)
	end
end

function s.damfilter(c)
	return c:IsFaceup() and c:IsCode(41418852)
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
	  and Duel.IsExistingMatchingCard(s.damfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil)
end
function s.filter1(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsControler(tp) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and c:IsLocation(LOCATION_REMOVED) and c:GetFlagEffect(612)~=0
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=e:GetLabelObject()
	local rg1=rg:Filter(s.filter1,nil,e,tp)
	local rgc=rg1:GetCount()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if rgc>ft then rgc=ft end
	if chk==0 then return (rg1:GetCount()==1 or Duel.IsPlayerCanSpecialSummonCount(tp,2)) and rg1:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,rg1,rgc,tp,LOCATION_REMOVED)	
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if not c:IsRelateToEffect(e) or ft<=0 then return end   
	local rg=e:GetLabelObject()
	local rg1=rg:Filter(s.filter1,nil,e,tp)
	local rgc=rg1:GetCount()	
	if rg1:GetCount()>1 and ft>1 and Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end   
	if rgc>ft then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local rg2=rg:Select(tp,ft,ft,nil)
		rg=rg2	  
		rgc=ft 
	end
	Duel.SpecialSummon(rg,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
	rg:DeleteGroup()
	Duel.BreakEffect()
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
		local token=Duel.CreateToken(tp,654)
		Duel.SpecialSummon(token,SUMMON_TYPE_XYZ,tp,1-tp,false,false,POS_FACEUP)
	end 
end

function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(592,RESET_EVENT+0x1fe0000,0,1)
end


