--Ultimitl Bishbalkin (K)
local s,id=GetID()
function s.initial_effect(c)
	aux.god(c,1,id,0)

    local e0 = Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_CANNOT_DISABLE)
    e0:SetCode(805)
    e0:SetValue(0)
    c:RegisterEffect(e0)

	c:EnableReviveLimit()
	Synchro.AddDarkSynchroProcedure(c,Synchro.NonTuner(Card.IsType,TYPE_SYNCHRO),nil,0)

	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(90884403,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetTarget(s.tg)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)

	local e22=Effect.CreateEffect(c)
	e22:SetDescription(aux.Stringid(90884403,0))
	e22:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e22:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e22:SetProperty(EFFECT_FLAG_DELAY)
	e22:SetCode(EVENT_SPSUMMON_SUCCESS)
	e22:SetTarget(s.tg)
	e22:SetOperation(s.op)
	c:RegisterEffect(e22)

	--Destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(327051,1))
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(s.desreptg)
	e5:SetOperation(s.desrepop)
	c:RegisterEffect(e5)

	local e114=Effect.CreateEffect(c)
	e114:SetType(EFFECT_TYPE_SINGLE)
	e114:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e114:SetCode(EFFECT_ADD_RACE)
	e114:SetValue(RACE_FIEND|RACE_DRAGON)
	c:RegisterEffect(e114)
	local e115=e114:Clone()
	e115:SetCode(EFFECT_ADD_ATTRIBUTE)
	e115:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e115)
end
s.listed_names={90884404}

function s.atkval(e,c)
		return Duel.GetFieldGroupCount(e:GetHandler():GetControler(),LOCATION_MZONE,LOCATION_MZONE)*1000
end

 function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0)
		and (Duel.IsPlayerCanSpecialSummonMonster(tp,90884404,0,0,0,0,1,RACE_FIEND,ATTRIBUTE_DARK) or Duel.IsPlayerCanSpecialSummonMonster(1-tp,90884404,0,0,0,0,1,RACE_FIEND,ATTRIBUTE_DARK)) end
	local count=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local count2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,count+count2,PLAYER_ALL,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,count+count2,PLAYER_ALL,0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)==0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,90884404,0,0,0,0,1,RACE_FIEND,ATTRIBUTE_DARK) and not Duel.IsPlayerCanSpecialSummonMonster(1-tp,90884404,0,0,0,0,1,RACE_FIEND,ATTRIBUTE_DARK) then return end
	local count=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local count2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then count=1 end
	if Duel.IsPlayerAffectedByEffect(1-tp,CARD_BLUEEYES_SPIRIT) then count2=1 end   
	for i=1,count do
		local token=Duel.CreateToken(tp,90884404)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UNRELEASABLE_SUM)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			token:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
			token:RegisterEffect(e2)
	end
	for i=1,count2 do
		local token2=Duel.CreateToken(tp,90884404)
		Duel.SpecialSummonStep(token2,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_UNRELEASABLE_SUM)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetValue(1)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			token2:RegisterEffect(e3,true)
			local e4=e3:Clone()
			e4:SetCode(EFFECT_UNRELEASABLE_NONSUM)
			token2:RegisterEffect(e4,true)
	end
	Duel.SpecialSummonComplete()
end

function s.matfilter1(c,syncard)
	return c:IsSetCard(0x301) and c:IsType(TYPE_TUNER) and c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard)
end
function s.matfilter2(c,syncard) 
	return c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard) and not c:IsType(TYPE_TUNER) and c:IsType(TYPE_SYNCHRO)
end
function s.synfilter1(c,lv,g1,g2,sc)
	local tlv=c:GetLevel()  
	if c:GetFlagEffect(100000147)==0 then   
	return g1:IsExists(s.synfilter3,1,nil,lv+tlv,c,sc)
	else
	return g1:IsExists(s.synfilter3,1,nil,lv-tlv,c,sc)
	end 
end
function s.synfilter3(c,lv,ntc,sc)
	return c:GetLevel()==lv and Duel.GetLocationCountFromEx(c:GetControler(),c:GetControler(),Group.FromCards(c,ntc),sc)>0
end
function s.filter3(c)
	return c:IsFaceup() and c:IsCode(344)
end
function s.syncon(e,c,tuner)
	if c==nil then return true end
	local tp=c:GetControler()
	local g1=Duel.GetMatchingGroup(s.matfilter1,tp,LOCATION_MZONE,0,nil,c)
	local g2=Duel.GetMatchingGroup(s.matfilter2,tp,LOCATION_MZONE,0,nil,c)
	local lv=0
	return g2:IsExists(s.synfilter1,1,nil,lv,g1,g2,c) and Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_GRAVE,0,1,nil)
end
function s.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner)
	local g=Group.CreateGroup()
	local g1=Duel.GetMatchingGroup(s.matfilter1,tp,LOCATION_MZONE,0,nil,c)
	local g2=Duel.GetMatchingGroup(s.matfilter2,tp,LOCATION_MZONE,0,nil,c)
	local lv=0
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local m3=g2:FilterSelect(tp,s.synfilter1,1,1,nil,lv,g1,g2,c)
		local mt1=m3:GetFirst()
		g:AddCard(mt1)
		local lv1=mt1:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		if mt1:GetFlagEffect(100000147)==0 then 
		local t1=g1:FilterSelect(tp,s.synfilter3,1,1,nil,lv+lv1,mt1,c)
		g:Merge(t1)
		else 
		local t1=g1:FilterSelect(tp,s.synfilter3,1,1,nil,lv-lv1,mt1,c)
		g:Merge(t1)
		end   
	c:SetMaterial(g)
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(100000150,2))
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(100000150,3))
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(100000150,4))
end

function s.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local a=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,c)
	if chk==0 then return c:IsOnField() and c:IsFaceup() and #a>0 end
	return Duel.SelectYesNo(tp,aux.Stringid(19333131,0))
end
function s.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,c)
	if #a>0 and Duel.Destroy(a,REASON_EFFECT+REASON_REPLACE)~=0 then
		local g=Duel.GetOperatedGroup()
		Duel.BreakEffect()
		Duel.Damage(1-tp,g:GetCount()*200,REASON_EFFECT)
	end
end